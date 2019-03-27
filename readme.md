分享一个gdb加载linux驱动符号的脚本。

使用方法：

- 打开脚本，修改倒数第二行中，load_mod_impl的两个参数，参数含义如下：
  - 第一个参数为module名字，如btrfs.ko，只需要填btrfs
  - 第二个参数为module的完整路径
- 启动gdb，attach内核后，`source mod_loader.gdb`
- 在gdb中执行`load_mod`

