# Namada-snapshot-automatic-synchronization
A script for automatically use snapshot synchronization for Namada rpc

If your node is struggling to keep up with the synchronization progress, this script can be used. It will automatically download a snapshot and use it for quick synchronization when your node falls behind by a specified number of blocks.
Here's how to use it:
1.screen -S auto_snapshot_update       # Use screen to create a window so that the script can run in the background
2.sudo wget https://raw.githubusercontent.com/smartpaopao/Namada-snapshot-automatic-synchronization/main/auto_snapshot_sync.sh && bash auto_snapshot_sync.sh       # Enter this command to run the script
3.Follow the prompts to enter the RPC port number and the number of blocks to fall behind for automatic synchronization
4.Press Ctrl+a then d to detach from the screen window


Enjoy it!
