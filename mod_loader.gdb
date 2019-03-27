#define initkdbg
#	file /usr/src/linux-source-4.4.0/linux-source-4.4.0/vmlinux
#	set serial baud 115200
#	target remote /dev/ttyS0
#	handle SIGSEGV noprint nostop pass
#end

define load_mod_impl
	set $offset =  ((int)&((struct module *)0)->list) 
        set $current = (struct module *)(((long)modules.next)-$offset)
    	printf "Module\tAddress\n"
 
    	while(($current)->list.next != modules.next)
		if($_streq($current->name, $arg0))
			printf "found module\n"
			set $i = 0L
			set $nr = ($current)->sect_attrs.nsections
			set $sect = ($current)->sect_attrs.attrs

			set $text_addr = 0L
			set $data_addr = 0L
			set $bss_addr = 0L
			while($i < $nr)
				printf "section:%s\t, addr:%p\n", ($sect)->name, ($sect)->address
				if($_streq(($sect)->name, ".text"))
					set $text_addr = ($sect)->address
				end
				if($_streq(($sect)->name, ".data"))
					set $data_addr = ($sect)->address
				end
				if($_streq(($sect)->name, ".bss"))
					set $bss_addr = ($sect)->address
				end
				set $i = $i + 1
				set $sect = (struct module_sect_attr *)((long)($sect) + sizeof(struct module_sect_attr))

			end
				printf "loading symbol...\n"
				add-symbol-file  $arg1  $text_addr -s .data $data_addr -s .bss $bss_addr
				printf "load end"
			loop_break
		end
                set $current = (struct module *)(((long)((struct module *)$current).list->next) - $offset)
    	end
end

define load_mod
	load_mod_impl "btrfs" "/usr/src/linux-source-4.4.0/linux-source-4.4.0/fs/btrfs/btrfs.ko" 
end
