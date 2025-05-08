module Guassnumber(
    input rst, clk,         // Reset signal and clock signal
    input add1, add10, sub1, sub10, // Buttons used during initial counting phase
    input add_1, add_2, add_3, add_5, add_10, sub_1, sub_2, // Buttons used during matching phase

    input clear,             // Clear button, enter the next phase
    output reg [7:0] se1, se2, // Display output
    output reg light_red, light_gre, light_yell         // Indicator light, shows successful match
);

    // 內部暫存器
    reg [7:0] count, memory, count_new; // 'memory' 用來儲存第一個想到的數字
    reg [7:0] ten, one, ten_new, one_new; // "ten, one" 表示十位和個位, "ten_new, one_new"同理但是會在第二階段(猜數字)會用到的register

    reg matchmode; // 用01判斷是否進入第二階段(猜數字)

    always @(posedge clk) begin
        if (rst) begin             // 初始化, 當rst按鈕

            se1 <= 8'hC0; // 顯示器沒東西, count為0
            se2 <= 8'hC0;
            memory <= count;
            count <= 0;
            count_new <= 0;
            matchmode <= 0;
            light_red <= 0;//燈不會亮
            light_gre <= 0;
            light_yell <= 0;
        end 
        else begin
            if (matchmode == 0) begin //matchmode為0表示在第一階段, 使用者可以設定數字
                // 初始計數階段
                if (add1 == 1 && count != 99) //這便提供使用者可以任意 +-1或+-10
                    count <= count + 1;	      // 為了控制範圍在0~99, 有設下一些規定
                else if (add1 == 1)
                    count <= 0;

                if (add10 == 1 && count < 90)
                    count <= count + 10;
                else if (add10 == 1)
                    count <= count - 90;

                if (sub1 == 1 && count != 0)
                    count <= count - 1;
                else if (sub1 == 1)
                    count <= 99;

                if (sub10 == 1 && count > 9)
                    count <= count - 10;
                else if (sub10 == 1)
                    count <= 99 - 9 + count;

                if (clear) begin // 按下清除按鈕，進入計數第二階段(猜數字)
  
                    se1 <= 8'hC0;
                    se2 <= 8'hC0;
                    memory <= count;    
                    count_new <= 0;
                    matchmode <= 1; // matchmode設定成1, 表示第二階段(猜數字)

                end

                // 將計數值分解為十位和個位以顯示, count為使用者一開始設定要給別人猜的數字
                ten = count / 10;
                one = count % 10;
		
		//同講義上的設定
                case (ten)
                    8'b00000000: se1 <= 8'hC0;
                    8'b00000001: se1 <= 8'hF9;
                    8'b00000010: se1 <= 8'hA4;
                    8'b00000011: se1 <= 8'hB0;
                    8'b00000100: se1 <= 8'h99;
                    8'b00000101: se1 <= 8'h92;
                    8'b00000110: se1 <= 8'h82;
                    8'b00000111: se1 <= 8'hF8;
                    8'b00001000: se1 <= 8'h80;
                    8'b00001001: se1 <= 8'h90;
                endcase
                case (one)
                    8'b00000000: se2 <= 8'hC0;
                    8'b00000001: se2 <= 8'hF9;
                    8'b00000010: se2 <= 8'hA4;
                    8'b00000011: se2 <= 8'hB0;
                    8'b00000100: se2 <= 8'h99;
                    8'b00000101: se2 <= 8'h92;
                    8'b00000110: se2 <= 8'h82;
                    8'b00000111: se2 <= 8'hF8;
                    8'b00001000: se2 <= 8'h80;
                    8'b00001001: se2 <= 8'h90;
                endcase
            end

            if (matchmode == 1) begin		// 計數匹配階段or第二階段(猜數字)
						//這邊提供玩家可以+1, 2, 3, 5, 10 
						//這邊提供玩家可以減1, 2

                if (add_1 == 1 && count_new < memory)
                    count_new <= count_new + 1;

                if (add_2 == 1 && count_new < memory)
                    count_new <= count_new + 2;

                if (add_3 == 1 && count_new < memory)
                    count_new <= count_new + 3;

                if (add_5 == 1 && count_new < memory)
                    count_new <= count_new + 5;

                if (add_10 == 1 && count_new < memory)
                    count_new <= count_new + 10;
                    
                if (sub_1 == 1 && count_new > memory)
                    count_new <= count_new - 1;
                
                if (sub_2 == 1 && count_new > memory)
                    count_new <= count_new - 2;

		// memory放第一階段, 使用者設定的數字
                // 當計數成功匹配時，指示燈亮起
                if (count_new > memory) // 玩家猜到的數字較大, 亮紅燈
                    light_red <= 1;
                else
                    light_red <= 0;
                    
                if (count_new == memory)// 玩家猜到的數字一模一樣, 亮綠燈
                    light_gre <= 1;
                else
                    light_gre <= 0;
                    
                if (count_new < memory)// 玩家猜到的數字較小, 亮黃燈
                    light_yell <= 1;
                else
                    light_yell <= 0;

                // 將計數值分解為十位和個位以顯示
                ten_new = count_new / 10;
                one_new = count_new % 10;
                
		//同講義上的設定
                case (ten_new)
                    8'b00000000: se1 <= 8'hC0;
                    8'b00000001: se1 <= 8'hF9;
                    8'b00000010: se1 <= 8'hA4;
                    8'b00000011: se1 <= 8'hB0;
                    8'b00000100: se1 <= 8'h99;
                    8'b00000101: se1 <= 8'h92;
                    8'b00000110: se1 <= 8'h82;
                    8'b00000111: se1 <= 8'hF8;
                    8'b00001000: se1 <= 8'h80;
                    8'b00001001: se1 <= 8'h90;
                endcase
                case (one_new)
                    8'b00000000: se2 <= 8'hC0;
                    8'b00000001: se2 <= 8'hF9;
                    8'b00000010: se2 <= 8'hA4;
                    8'b00000011: se2 <= 8'hB0;
                    8'b00000100: se2 <= 8'h99;
                    8'b00000101: se2 <= 8'h92;
                    8'b00000110: se2 <= 8'h82;
                    8'b00000111: se2 <= 8'hF8;
                    8'b00001000: se2 <= 8'h80;
                    8'b00001001: se2 <= 8'h90;
                endcase
            end
        end
    end
endmodule