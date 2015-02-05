# FIFOs

I studied and designed different FIFOs during different courses. Summerize them here.

###### [Most Basic FIFO](https://github.com/CWang24/DDR2_Controller/blob/master/FIFO.v)
Never assume that basic = easy. Actually this "most basic FIFO" plays a key role in the project [DDR Controller](). In order to narrow the clock period so that this DDR2/DDR3 could run in a high frequency, the FIFO need to be as concise as possible while maintain the correct function and timing. As far as I know, many groups met with slack violated issues after running synthesis. And usually a path inside FIFO or involves FIFO make the longest path. 

###### Expanding Width and Depth of FIFO


##### A double clock FIFO
