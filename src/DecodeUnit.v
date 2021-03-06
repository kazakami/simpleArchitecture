module DecodeUnit(
   input [15:0] COMMAND,
   output 	signEx,
   output 	AR_MUX, BR_MUX,
   output [3:0] S_ALU,
   output 	INPUT_MUX, writeEnable,
   output [2:0] writeAddress,
   output 	ADR_MUX, write, PC_load,
   output [2:0] cond, op2
);

   reg [3:0] 	Select_ALU;
   reg [2:0] 	condition;
   reg [2:0] 	opera2;
   localparam 	IADD = 4'b0000;
   localparam 	ISUB = 4'b0001;
   localparam 	IAND = 4'b0010;
   localparam 	IOR = 4'b0011;
   localparam 	IXOR = 4'b0100;
   localparam 	ISLL = 4'b1000;
   localparam 	ISLR = 4'b1001;
   localparam 	ISRL = 4'b1010;
   localparam 	ISRA = 4'b1011;
   localparam 	IIDT = 4'b1100;
   localparam 	INON = 4'b1111;

   reg [2:0] 	wrAdr; 	
   reg 		wr, pcl, in, adr, ar, br, se, wren;


   //wrAdr
   always @ (COMMAND) begin
     if (COMMAND[15:14] == 2'b00)
       wrAdr <= COMMAND[13:11];
     else
       wrAdr <= COMMAND[10:8];
   end
   
   //cond
   always @ (COMMAND) begin
      condition <= COMMAND[10:8];
   end

   //op2
   always @ (COMMAND) begin
      opera2 <= COMMAND[13:11];
   end
   
   //wren
   always @ (COMMAND) begin
      if (COMMAND[15:14] == 2'b01)
	wren <= 1;
      else
	wren <= 0;
   end
     
   //signEx
   always @ (COMMAND) begin
      if (COMMAND[15:14] != 2'b11)
	se <= 1;
      else
	se <= 0;
   end   

   //write
   always @ (COMMAND) begin
      if ((COMMAND[15:14] == 2'b11 && (COMMAND[7:4] <= 4'b1100 && COMMAND[7:4] != 4'b0101)) ||
	  COMMAND[15:14] == 2'b00 ||
	  COMMAND[15:12] == 5'b1000)
	wr <= 1;
      else
	wr <=0;
   end

   //PC_load
   always @ (COMMAND) begin
      if (COMMAND[15:11] == 5'b10100 || COMMAND[15:11] == 5'b10111)
	pcl <= 1;
      else
	pcl <= 0;
   end

   //INPUT_MUX
   always @ (COMMAND) begin
      if (COMMAND[15:14] == 2'b11 && COMMAND[7:4] == 4'b1100)
	in <= 1;
      else
	in <= 0;
   end

   //ADR_MUX
   always @ (COMMAND) begin
      if ((COMMAND[15:14] == 2'b11 && COMMAND[7:4] <= 4'b1011) ||COMMAND[15:14] == 2'b10)
	adr <= 1;
      else
	adr <= 0;
   end

   //BR_MUX
   always @ (COMMAND) begin
      if (COMMAND[15:14] != 2'b10 || COMMAND[13] != 1'b1)
	br <= 1;
      else
	br <= 0;
   end

   //AR_MUX
   always @ (COMMAND) begin
      if (COMMAND[15:14] == 2'b11 && COMMAND[7:4] <= 4'b0110)
	ar <= 1;
      else
	ar <= 0;
   end
   
   //各種演算命令
   always @ (COMMAND) begin
      if (COMMAND[15:14] == 2'b11)//演算命令
	case (COMMAND[7:4])
	  4'b0101 : Select_ALU <= ISUB;//CMP
	  4'b0110 : Select_ALU <= IIDT;//MOV
	  default : Select_ALU <= COMMAND[7:4];
	endcase // case (COMMAND[7:4])
      else if (COMMAND[15] == 1'b0)//LD, ST
	Select_ALU <= IADD;
      else if (COMMAND[15:11] == 5'b10000)//LI
	Select_ALU <= IIDT;
      else if (COMMAND[15:11] == 5'b10001)//ADDI
	Select_ALU <= IADD;
      else if (COMMAND[15:11] == 5'b10100)//分岐
	Select_ALU <= IADD;
      else if (COMMAND[15:11] == 5'b10111)//条件分岐
	Select_ALU <= IADD;
      else//その他
	Select_ALU <= INON;
   end

   assign op2 = opera2;
   assign writeAddress = wrAdr;
   assign S_ALU = Select_ALU;
   assign cond = condition;
   assign AR_MUX = ar;
   assign BR_MUX = br;
   assign write = wr;
   assign PC_load = pcl;
   assign INPUT_MUX = in;
   assign ADR_MUX = adr;
   assign signEx = se;
   assign writeEnable = wren;   
   
endmodule // DecodeUnit
