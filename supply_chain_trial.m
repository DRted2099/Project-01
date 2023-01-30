% READ ME %%
% Change the file location to the file path on your PC to run the code
% Decrease number of cycles to decrease run time
%


clc;
clear;
close all;

% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 5);

% Specify sheet and range
opts.Sheet = "Routing";
opts.DataRange = "A2:E58";

% Specify column names and types
opts.VariableNames = ["PartNo", "WorkCenterNo", "SequenceNo", "Avg_Hours", "Std_Dev_"];
opts.VariableTypes = ["string", "categorical", "string", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, ["PartNo", "SequenceNo"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["PartNo", "WorkCenterNo", "SequenceNo"], "EmptyFieldRule", "auto");

% Import the data
Prod_tab = readtable("/MATLAB Drive/FFS_INPUT_FILE_2.xlsx", opts, "UseExcel", false);


% Clear temporary variables
clear opts

% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 6);

% Specify sheet and range
opts.Sheet = "Demand";
opts.DataRange = "A2:F3";

% Specify column names and types
opts.VariableNames = ["Var1", "Product", "x124672", "x126054", "x126293", "x121757"];
opts.VariableTypes = ["string", "string", "double", "double", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Product"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Product"], "EmptyFieldRule", "auto");

% Import the data
Demand_tab = readtable("/MATLAB Drive/FFS_INPUT_FILE_2.xlsx", opts, "UseExcel", false);


% Clear temporary variables
clear opts
%
% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 7);

% Specify sheet and range
opts.Sheet = "Workcenter";
opts.DataRange = "A2:G14";

% Specify column names and types
opts.VariableNames = ["WorkCenterNo", "Description", "Area", "CostOfWC", "SetupTime", "Avg_RunHrs_noBreakdown_", "Std_DevForBreakdown"];
opts.VariableTypes = ["string", "string", "double", "double", "double", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, ["WorkCenterNo", "Description"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["WorkCenterNo", "Description"], "EmptyFieldRule", "auto");

% Import the data
Master_tab = readtable("/MATLAB Drive/FFS_INPUT_FILE_2.xlsx", opts, "UseExcel", false);


% Clear temporary variables
clear opts



% Assuming Mean Downtime of 6 hours with a standard deviation of 0.5 hours

cycles = 10 * 10^3;

Index_Part1 = find(strcmp(Prod_tab.PartNo, "124672"));

Index_Part2 = find(strcmp(Prod_tab.PartNo, "126054"));

Index_Part3 = find(strcmp(Prod_tab.PartNo, "126293"));

Index_Part4 = find(strcmp(Prod_tab.PartNo, "121757"));

Part1 = Prod_tab(Index_Part1,:);
Part2 = Prod_tab(Index_Part2,:);
Part3 = Prod_tab(Index_Part3,:);
Part4 = Prod_tab(Index_Part4,:);

Index_CNC = find(strcmp(Master_tab.WorkCenterNo, "CNC HORIZ"));
Index_DRESS = find(strcmp(Master_tab.WorkCenterNo, "DRESS"));
Index_DRESS_BAL = find(strcmp(Master_tab.WorkCenterNo, "DRESS BAL"));
Index_MAN_KEY = find(strcmp(Master_tab.WorkCenterNo, "MAN KEY"));
Index_MAN_MILL = find(strcmp(Master_tab.WorkCenterNo, "MAN MILL"));
Index_MAN = find(strcmp(Master_tab.WorkCenterNo, "MAN SFTLTH"));
Index_TEST = find(strcmp(Master_tab.WorkCenterNo, "TESTING"));


[CNC_br_mean, CNC_br_std, CNC_stup] = deal(Master_tab.Avg_RunHrs_noBreakdown_(Index_CNC),...
    Master_tab.Std_DevForBreakdown(Index_CNC), Master_tab.SetupTime(Index_CNC));

[Dress_br_mean, Dress_br_std, Dress_stup] = deal(Master_tab.Avg_RunHrs_noBreakdown_(Index_DRESS),...
    Master_tab.Std_DevForBreakdown(Index_DRESS), Master_tab.SetupTime(Index_DRESS));

[DB_br_mean, DB_br_std, DB_stup] = deal(Master_tab.Avg_RunHrs_noBreakdown_(Index_DRESS_BAL),...
    Master_tab.Std_DevForBreakdown(Index_DRESS_BAL), Master_tab.SetupTime(Index_DRESS_BAL));

[MK_br_mean, MK_br_std, MK_stup] = deal(Master_tab.Avg_RunHrs_noBreakdown_(Index_MAN_KEY),...
    Master_tab.Std_DevForBreakdown(Index_MAN_KEY), Master_tab.SetupTime(Index_MAN_KEY));

[MM_br_mean, MM_br_std, MM_stup] = deal(Master_tab.Avg_RunHrs_noBreakdown_(Index_MAN_MILL),...
    Master_tab.Std_DevForBreakdown(Index_MAN_MILL), Master_tab.SetupTime(Index_MAN_MILL));

[Man_br_mean, Man_br_std, Man_stup] = deal(Master_tab.Avg_RunHrs_noBreakdown_(Index_MAN),...
    Master_tab.Std_DevForBreakdown(Index_MAN), Master_tab.SetupTime(Index_MAN));

[Test_br_mean, Test_br_std, Test_stup] = deal(Master_tab.Avg_RunHrs_noBreakdown_(Index_TEST),...
    Master_tab.Std_DevForBreakdown(Index_TEST), Master_tab.SetupTime(Index_TEST));


Crim = [0.68,0.03,0];




%Product 1 -  124672 

% Assuming Mean Downtime of 6 hours with a standard deviation of 0.5 hours
% Breakdown
 

Part1_cyc_std = [Part1.Avg_Hours(:) Part1.Std_Dev_(:)];

QA_std = 2;
Shi_std = 0.75;

% rec_cyc1 = normrnd(3.18,1); %Rec

% QA_cyc2 = normrnd(5.79,QA_std); %QA Inspect

[cnc_br3,~,cnc_stup3] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[cnc_br4,~,cnc_stup4] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[cnc_br5,~,cnc_stup5] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[man_br6,~,man_stup6] = Man_Sftlth(Man_br_mean,Man_br_std,0,0,Man_stup);

[cnc_br7,~,cnc_stup7] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[cnc_br8,~,cnc_stup8] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[cnc_br9,~,cnc_stup9] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[mm_br10, ~, mm_stup10] = Man_Mill(MM_br_mean,MM_br_std,0,0,MM_stup);

[mk_br11, ~, mk_stup11] = Man_Key(MK_br_mean,MK_br_std,0,0,MK_stup);

% QA_cyc12 = normrnd(9,QA_std);

[dress_br13, ~, dress_stup13] = Dress(Dress_br_mean,Dress_br_std,0,0,...
    Dress_stup);

% QA_cyc14 = normrnd(2.88,QA_std);

% Assem_cyc15 = normrnd(4.44, 0.5);

[dressbal_br16, ~, dressbal_stup16] = Dress_Bal(DB_br_mean,...
    DB_br_std,0,0,DB_stup);

[dressbal_br17, ~, dressbal_stup17] = Dress_Bal(DB_br_mean, DB_br_std,...
    0,0,DB_stup);

% QA_cyc18 = normrnd(4.54, QA_std);

% Shi_cyc19 = normrnd(2.37, Shi_std);

[temp_cnc3 ,temp_cnc4, temp_cnc5, temp_man6, temp_cnc7, temp_cnc8, temp_cnc9,...
    temp_mm10, temp_mk11, temp_dress13, temp_dressbal16, temp_dressbal17]...
    = deal(0);


for i = 1:cycles

   rec_cyc1(i) = abs(normrnd(3.18,1));  %REC1

   QA_cyc2(i) = abs(normrnd(5.79,QA_std));  %QA2

   if i >1

       if QA_cyc2(i) > rec_cyc1(i-1)
    
           QA_cyc2_wait_time = QA_cyc2(i) - rec_cyc1(i-1);
    
           QA_cyc2(i) = QA_cyc2_wait_time + abs(normrnd(5.79,QA_std));
    
       else
           
           QA_cyc2_wait_time = 0;
    
       end

   end

      
   if temp_cnc3 >= cnc_br3   %CNC3

       
       [cnc_br3,cnc_cyc3,~] =  Cnc_horiz(CNC_br_mean,CNC_br_std,Part1_cyc_std(3,1)...
           ,Part1_cyc_std(3,2),0);

       temp_cnc3 = 0;
       
       cnc3_sum(i) = cnc_cyc3 + abs(normrnd(6,0.5));

       temp_cnc3 = temp_cnc3 + cnc3_sum(i);

       if i > 1

           if cnc3_sum(i) > QA_cyc2(i-1)
    
               cnc3_wait_time = cnc3_sum(i) - QA_cyc2(i-1);
                   
               cnc3_sum(i) = cnc_cyc3 + cnc3_wait_time;
    
           else

                cnc3_wait_time = 0;

                cnc3_sum(i) = cnc_cyc3 + cnc3_wait_time;
    
           end

       end


   else

       [~,cnc_cyc3,~] = Cnc_horiz(0,0,Part1_cyc_std(3,1),Part1_cyc_std(3,2),0);
       
       cnc3_sum(i) = cnc_cyc3 ;

       temp_cnc3 = temp_cnc3 + cnc3_sum(i);

       if i > 1

           if cnc3_sum(i) > QA_cyc2(i-1)
    
               cnc3_wait_time = cnc3_sum(i) - QA_cyc2(i-1);
                   
               cnc3_sum(i) = cnc_cyc3 + cnc3_wait_time;
    
           else

                cnc3_wait_time = 0;

                cnc3_sum(i) = cnc_cyc3 + cnc3_wait_time;
    
           end

       end

   end

   if temp_cnc4 >= cnc_br4      %CNC4


       [cnc_br4,cnc_cyc4,~] = Cnc_horiz(CNC_br_mean,CNC_br_std,Part1_cyc_std(4,1)...
           ,Part1_cyc_std(4,2),0);

       temp_cnc4 = 0;

       cnc4_sum(i) =  cnc_cyc4 + abs(normrnd(6,0.5));

       temp_cnc4 = temp_cnc4 + cnc4_sum(i);

       if i > 1


           if cnc4_sum(i) > cnc3_sum(i-1)
    
               cnc4_wait_time = cnc4_sum(i) - cnc3_sum(i-1);
                   
               cnc4_sum(i) = cnc_cyc4 + cnc4_wait_time;
    
           else
               
               cnc4_wait_time = 0;

               cnc4_sum(i) = cnc_cyc4 + cnc4_wait_time;
    
           end  

       end

   else

       [~,cnc_cyc4,~] = Cnc_horiz(0,0,Part1_cyc_std(4,1),Part1_cyc_std(4,2),0);
       
       cnc4_sum(i) =  cnc_cyc4;
       
       temp_cnc4 = temp_cnc4 + cnc4_sum(i) ;

       if i > 1


           if cnc4_sum(i) > cnc3_sum(i-1)
    
               cnc4_wait_time = cnc4_sum(i) - cnc3_sum(i-1);
                   
               cnc4_sum(i) = cnc_cyc4 + cnc4_wait_time;
    
           else
               
               cnc4_wait_time = 0;

               cnc4_sum(i) = cnc_cyc4 + cnc4_wait_time;
    
           end 

       end

   end

   if temp_cnc5 >= cnc_br5   %CNC5

       [cnc_br5,cnc_cyc5,~] = Cnc_horiz(CNC_br_mean,CNC_br_std,Part1_cyc_std(5,1)...
           ,Part1_cyc_std(5,2),0);

       temp_cnc5 = 0;

       cnc5_sum(i) = cnc_cyc5 + abs(normrnd(6,0.5));

       temp_cnc5 = temp_cnc5 + cnc5_sum(i);

       if i > 1


           if cnc5_sum(i) > cnc4_sum(i-1)
    
               cnc5_wait_time = cnc5_sum(i) - cnc4_sum(i-1);
    
               cnc5_sum(i) = cnc_cyc5 + cnc5_wait_time;
    
           else
    
               cnc5_wait_time = 0;

               cnc5_sum(i) = cnc_cyc5 + cnc5_wait_time;
    
           end

       end

   else

       [~,cnc_cyc5,~] = Cnc_horiz(0,0,Part1_cyc_std(5,1),Part1_cyc_std(5,2),0);
       
       cnc5_sum(i) = cnc_cyc5;

       temp_cnc5 = temp_cnc5 + cnc5_sum(i);

       if i > 1

           if cnc5_sum(i) > cnc4_sum(i-1)
    
               cnc5_wait_time = cnc5_sum(i) - cnc4_sum(i-1);

               cnc5_sum(i) = cnc_cyc5 + cnc5_wait_time;
    
           else

               cnc5_wait_time = 0;

               cnc5_sum(i) = cnc_cyc5 + cnc5_wait_time;
    
           end

       end

   end

   if temp_man6 >= man_br6  % MAN6


       [man_br6,man_cyc6,~] = Man_Sftlth(Man_br_mean,Man_br_std,Part1_cyc_std(6,1),...
           Part1_cyc_std(6,2),0);

       temp_man6 = 0;

       man6_sum(i) =  man_cyc6 + abs(normrnd(6,0.5));

       temp_man6 = temp_man6 + man6_sum(i);

       if i > 1

           if man6_sum(i) > cnc5_sum(i-1)
    
               man6_wait_time = man6_sum(i) - cnc5_sum(i-1);

               man6_sum(i) = man_cyc6 + man6_wait_time;
    
           else
    
               man6_wait_time = 0;

               man6_sum(i) = man_cyc6 + man6_wait_time;
    
           end

       end

   else

       [~,man_cyc6,~] = Man_Sftlth(0,0,Part1_cyc_std(6,1),Part1_cyc_std(6,2),0);
       
       man6_sum(i) =  man_cyc6;

       temp_man6 = temp_man6 + man6_sum(i);

       if i > 1

           if man6_sum(i) > cnc5_sum(i-1)
    
               man6_wait_time = man6_sum(i) - cnc5_sum(i-1);

               man6_sum(i) = man_cyc6 + man6_wait_time;
    
           else

               man6_wait_time = 0;

               man6_sum(i) = man_cyc6 + man6_wait_time;
    
           end

       end

   end

   if temp_cnc7 >= cnc_br7  %CNC7


       [cnc_br7,cnc_cyc7,~] = Cnc_horiz(CNC_br_mean,CNC_br_std,Part1_cyc_std(7,1)...
           ,Part1_cyc_std(7,2),0);

       temp_cnc7 = 0;

       cnc7_sum(i) = cnc_cyc7 + abs(normrnd(6,0.5));

       temp_cnc7 = temp_cnc7 + cnc7_sum(i);  

       if i > 1
       
           if cnc7_sum(i) > man6_sum(i-1)
    
               cnc7_wait_time = cnc7_sum(i) - man6_sum(i-1);

               cnc7_sum(i) = cnc_cyc7 + cnc7_wait_time;
    
           else

               cnc7_wait_time = 0;

               cnc7_sum(i) = cnc_cyc7 + cnc7_wait_time;
    
           end

       end

   else

       [~,cnc_cyc7,~] = Cnc_horiz(0,0,Part1_cyc_std(7,1),Part1_cyc_std(7,2),0);
       
       cnc7_sum(i) = cnc_cyc7 ;

       temp_cnc7 = temp_cnc7 + cnc7_sum(i);  

       if i > 1
       
           if cnc7_sum(i) > man6_sum(i-1)
    
               cnc7_wait_time = cnc7_sum(i) - man6_sum(i-1);

               cnc7_sum(i) = cnc_cyc7 + cnc7_wait_time;
    
           else

               cnc7_wait_time = 0;

               cnc7_sum(i) = cnc_cyc7 + cnc7_wait_time;
    
           end

       end

   end   

   if temp_cnc8 >= cnc_br8  %CNC8


       [cnc_br8,cnc_cyc8,~] = Cnc_horiz(CNC_br_mean,CNC_br_std,Part1_cyc_std(8,1)...
           ,Part1_cyc_std(8,2),0);

       temp_cnc8 = 0;

       cnc8_sum(i) = cnc_cyc8 + abs(normrnd(6,0.5));

       temp_cnc8 = temp_cnc8 + cnc8_sum(i); 

       if i > 1
       
           if cnc8_sum(i) > cnc7_sum(i-1)
    
               cnc8_wait_time = cnc8_sum(i) - cnc7_sum(i-1);
               
               cnc8_sum(i) = cnc_cyc8 + cnc8_wait_time;
    
           else
    
                cnc8_wait_time = 0;

                cnc8_sum(i) = cnc_cyc8 + cnc8_wait_time;
    
           end

       end

   else

       [~,cnc_cyc8,~] = Cnc_horiz(0,0,Part1_cyc_std(8,1),Part1_cyc_std(8,2),0);
       
       cnc8_sum(i) = cnc_cyc8 ;

       temp_cnc8 = temp_cnc8 + cnc8_sum(i);

       if i > 1

           if cnc8_sum(i) > cnc7_sum(i-1)
    
               cnc8_wait_time = cnc8_sum(i) - cnc7_sum(i-1);

               cnc8_sum(i) = cnc_cyc8 + cnc8_wait_time;
    
           else
    
                cnc8_wait_time = 0;

                cnc8_sum(i) = cnc_cyc8 + cnc8_wait_time;
    
           end

       end


   end

   if temp_cnc9 >= cnc_br9  %CNC9


       [cnc_br9,cnc_cyc9,~] = Cnc_horiz(CNC_br_mean,CNC_br_std,Part1_cyc_std(9,1)...
           ,Part1_cyc_std(9,2),0);

       temp_cnc9 = 0;

       cnc9_sum(i) = cnc_cyc9 + abs(normrnd(6,0.5));

       temp_cnc9 = temp_cnc9 + cnc9_sum(i);

       if i > 1

           if cnc9_sum(i) > cnc8_sum(i-1)
    
               cnc9_wait_time = cnc9_sum(i) - cnc8_sum(i-1);

               cnc9_sum(i) = cnc_cyc9 + cnc9_wait_time;
    
           else

                cnc9_wait_time = 0;  

                cnc9_sum(i) = cnc_cyc9 + cnc9_wait_time;
    
           end

       end

   else

       [~,cnc_cyc9,~] = Cnc_horiz(0,0,Part1_cyc_std(9,1),Part1_cyc_std(9,2),0);
       
       cnc9_sum(i) = cnc_cyc9;

       temp_cnc9 = temp_cnc9 + cnc9_sum(i);

       if i > 1

           if cnc9_sum(i) > cnc8_sum(i-1)
    
               cnc9_wait_time = cnc9_sum(i) - cnc8_sum(i-1);
    
               cnc9_sum(i) = cnc_cyc9 + cnc9_wait_time;
    
           else

                cnc9_wait_time = 0;  

                cnc9_sum(i) = cnc_cyc9 + cnc9_wait_time;
    
           end

       end

   end

   if temp_mm10 >= mm_br10    %MM10


       [mm_br10,mm_cyc10,~] = Man_Mill(MM_br_mean,MM_br_std,Part1_cyc_std(10,1),...
           Part1_cyc_std(10,2),0);

       temp_mm10 = 0;

       mm10_sum(i) = mm_cyc10 + abs(normrnd(6,0.5));

       temp_mm10 = temp_mm10 + mm10_sum(i);

       if i > 1

           if mm10_sum(i) > cnc9_sum(i-1)
    
               mm10_wait_time = mm10_sum(i) - cnc9_sum(i-1);

               mm10_sum(i) = mm_cyc10 + mm10_wait_time;
    
           else
    
               mm10_wait_time = 0;

               mm10_sum(i) = mm_cyc10 + mm10_wait_time;
    
           end

       end

   else

       [~,mm_cyc10,~] = Man_Mill(0,0,Part1_cyc_std(10,1),Part1_cyc_std(10,2),0);
       
       mm10_sum(i) = mm_cyc10 ;

       temp_mm10 = temp_mm10 + mm10_sum(i); 

       if i > 1

           if mm10_sum(i) > cnc9_sum(i-1)
    
               mm10_wait_time = mm10_sum(i) - cnc9_sum(i-1);
 
               mm10_sum(i) = mm_cyc10 + mm10_wait_time;
    
           else
    
               mm10_wait_time = 0;

               mm10_sum(i) = mm_cyc10 + mm10_wait_time;
    
           end

       end

    end


  if temp_mk11 >= mk_br11   %MK11


       [mk_br11,mk_cyc11,~] = Man_Key(MK_br_mean,MK_br_std,Part1_cyc_std(11,1)...
           ,Part1_cyc_std(11,2),0);

       temp_mk11 = 0;

       mk11_sum(i) = mk_cyc11 + abs(normrnd(6,0.5));

       temp_mk11 = temp_mk11 + mk11_sum(i);  

       if i > 1
       
           if mk11_sum(i) > mm10_sum(i-1)
    
               mk11_wait_time = mk11_sum(i) - mm10_sum(i-1);
               
               mk11_sum(i) = mk_cyc11 + mk11_wait_time;
    
           else
    
                mk11_wait_time = 0;

                mk11_sum(i) = mk_cyc11 + mk11_wait_time;
    
           end

       end

   else

       [~,mk_cyc11,~] = Man_Key(0,0,Part1_cyc_std(11,1),Part1_cyc_std(11,2),0);
       
       mk11_sum(i) = mk_cyc11;

       temp_mk11 = temp_mk11 + mk11_sum(i);

       if i >1

           if mk11_sum(i) > mm10_sum(i-1)
    
               mk11_wait_time = mk11_sum(i) - mm10_sum(i-1);
    
               mk11_sum(i) = mk_cyc11 + mk11_wait_time;
    
           else
    
                mk11_wait_time = 0;

                mk11_sum(i) = mk_cyc11 + mk11_wait_time;
    
           end

       end

  end
  
  QA_cyc12(i) = abs(normrnd(9,QA_std)); %QA12

  if i > 1
    
      if QA_cyc12(i) > mk11_sum(i-1)
          
          QA_cyc12_wait_time = QA_cyc12(i) - mk11_sum(i-1);
        
          QA_cyc12(i) = abs(normrnd(9,QA_std)) + QA_cyc12_wait_time;
    
      else  
    
           QA_cyc12_wait_time = 0;

           QA_cyc12(i) = abs(normrnd(9,QA_std)) + QA_cyc12_wait_time;
    
      end

  end

  if temp_dress13 >= dress_br13 %D13


       [dress_br13,dress_cyc13,~] = Dress(Dress_br_mean,Dress_br_std,...
           Part1_cyc_std(13,1),Part1_cyc_std(13,2),0);

       temp_dress13 = 0;

       dress13_sum(i) = dress_cyc13 + abs(normrnd(6,0.5));

       temp_dress13 = temp_dress13 + dress13_sum(i);

       if i > 1

           if dress13_sum(i) > QA_cyc12(i-1)
    
              dress13_wait_time =  dress13_sum(i) - QA_cyc12(i-1);

              dress13_sum(i) = dress_cyc13 + dress13_wait_time;
    
           else
    
               dress13_wait_time = 0;

               dress13_sum(i) = dress_cyc13 + dress13_wait_time;
    
           end

       end

  else

       [~,dress_cyc13,~] = Dress(0,0,Part1_cyc_std(13,1),Part1_cyc_std(13,2),0);

       dress13_sum(i) = dress_cyc13;

       temp_dress13 = temp_dress13 + dress13_sum(i);

       if i > 1

           if dress13_sum(i) > QA_cyc12(i-1)
    
              dress13_wait_time =  dress13_sum(i) - QA_cyc12(i-1);

              dress13_sum(i) = dress_cyc13 + dress13_wait_time;
    
           else

               dress13_wait_time = 0;

               dress13_sum(i) = dress_cyc13 + dress13_wait_time;
    
           end

       end
  end

  
  QA_cyc14(i) = abs(normrnd(2.88,QA_std));  %QA14

  if i > 1

      if QA_cyc14(i) > dress13_sum(i-1)
    
          QA_cyc14_wait_time = QA_cyc14(i) - dress13_sum(i-1);
    
          QA_cyc14(i) = abs(normrnd(2.88,QA_std)) + QA_cyc14_wait_time;
    
      else

    
          QA_cyc14_wait_time = 0;

          QA_cyc14(i) = abs(normrnd(2.88,QA_std)) + QA_cyc14_wait_time;
    
      end

  end

  
  Assem_cyc15(i) = abs(normrnd(4.44, 0.5)); %ASSEM15

  if i > 1

      if Assem_cyc15(i) > QA_cyc14(i-1)
    
          Assem_cyc15_wait_time = Assem_cyc15(i) - QA_cyc14(i-1);
    
          Assem_cyc15(i) = abs(normrnd(4.44, 0.5)) + Assem_cyc15_wait_time;
    
      else
    
    
           Assem_cyc15_wait_time = 0;

           Assem_cyc15(i) = abs(normrnd(4.44, 0.5)) + Assem_cyc15_wait_time;
    
      end

  end

 if temp_dressbal16 >= dressbal_br16   %DB16


       [dressbal_br16,dressbal_cyc16,~] = Dress_Bal(DB_br_mean,...
    DB_br_std,Part1_cyc_std(16,1),Part1_cyc_std(16,2),0);

       temp_dressbal16 = 0;

       dressbal16_sum(i) = dressbal_cyc16 + abs(normrnd(6,0.5));

       temp_dressbal16 = temp_dressbal16 + dressbal16_sum(i);

       if i > 1 

           if dressbal16_sum(i) > Assem_cyc15(i-1)
    
               dressbal16_wait_time = dressbal16_sum(i) - Assem_cyc15(i-1);

               dressbal16_sum(i) = dressbal_cyc16 + dressbal16_wait_time;
    
           else

               dressbal16_wait_time = 0;

               dressbal16_sum(i) = dressbal_cyc16 + dressbal16_wait_time;
    
           end

       end

  else

       [~,dressbal_cyc16,~] = Dress_Bal(0,0,Part1_cyc_std(16,1),...
           Part1_cyc_std(16,2),0);
       
       dressbal16_sum(i) = dressbal_cyc16;

       temp_dressbal16 = temp_dressbal16 + dressbal16_sum(i); 

       if i > 1
       
           if dressbal16_sum(i) > Assem_cyc15(i-1)
    
               dressbal16_wait_time = dressbal16_sum(i) - Assem_cyc15(i-1);

               dressbal16_sum(i) = dressbal_cyc16 + dressbal16_wait_time;
    
           else
    
               dressbal16_wait_time = 0;

               dressbal16_sum(i) = dressbal_cyc16 + dressbal16_wait_time;
    
           end

       end

 end

 if temp_dressbal17 >= dressbal_br17 %DB17


   [dressbal_br17,dressbal_cyc17,~] = Dress_Bal(DB_br_mean,...
    DB_br_std,Part1_cyc_std(17,1),Part1_cyc_std(17,2),0);

   temp_dressbal17 = 0;

   dressbal17_sum(i) = dressbal_cyc17 + abs(normrnd(6,0.5));

   temp_dressbal17 = temp_dressbal17 + dressbal17_sum(i);

   if i > 1

       if dressbal17_sum(i) > dressbal16_sum(i-1)
    
               dressbal17_wait_time = dressbal17_sum(i) - dressbal16_sum(i-1);

               dressbal17_sum(i) = dressbal_cyc17 + dressbal17_wait_time;
    
       else
    
           dressbal17_wait_time = 0;

           dressbal17_sum(i) = dressbal_cyc17 + dressbal17_wait_time;
    
       end

   end

 else

     [~,dressbal_cyc17,~] = Dress_Bal(0,0,Part1_cyc_std(17,1),Part1_cyc_std(17,2),0);
       
     dressbal17_sum(i) = dressbal_cyc17 ;

     temp_dressbal17 = temp_dressbal17 + dressbal17_sum(i);

     if i > 1

       if dressbal17_sum(i) > dressbal16_sum(i-1)
    
           dressbal17_wait_time = dressbal17_sum(i) - dressbal16_sum(i-1);

           dressbal17_sum(i) = dressbal_cyc17 + dressbal17_wait_time;
    
       else
    
           dressbal17_wait_time = 0;

           dressbal17_sum(i) = dressbal_cyc17 + dressbal17_wait_time;
    
       end

     end
 
 end

QA_cyc18(i) = abs(normrnd(4.54, QA_std)); %QA18

if i > 1

    if  QA_cyc18(i) > dressbal17_sum(i-1)
    
        QA_cyc18_wait_time = QA_cyc18(i) - dressbal17_sum(i-1);
        
        QA_cyc18(i) = abs(normrnd(4.54, QA_std)) + QA_cyc18_wait_time;
    
    else
    
         QA_cyc18_wait_time = 0;

         QA_cyc18(i) = abs(normrnd(4.54, QA_std)) + QA_cyc18_wait_time;

    end

end
    
Shi_cyc19(i) = abs(normrnd(2.37, Shi_std)); %SHI19

if i > 1

    if  Shi_cyc19(i) > QA_cyc18(i-1)
    
        Shi_cyc19_wait_time = Shi_cyc19(i) - QA_cyc18(i-1);
        
        Shi_cyc19(i) = abs(normrnd(2.37, Shi_std)) + Shi_cyc19_wait_time;
    
    else
    
    
         Shi_cyc19_wait_time = 0;

         Shi_cyc19(i) = abs(normrnd(2.37, Shi_std)) + Shi_cyc19_wait_time;
    end

end


%REC1


REC1(i,1) = rec_cyc1(i);

%QA2

QA2(i,1) = QA_cyc2(i);


%CNC3
CNC3(i,1) = cnc3_sum(i);
CNC3(i,2) = cnc_br3;
CNC3(i,3) = temp_cnc3;


%CNC4
CNC4(i,1) = cnc4_sum(i);
CNC4(i,2) = cnc_br4;
CNC4(i,3) = temp_cnc4;

%CNC5
CNC5(i,1) = cnc5_sum(i);
CNC5(i,2) = cnc_br5;
CNC5(i,3) = temp_cnc5;


%Man6
Man6(i,1) = man6_sum(i);
Man6(i,2) = man_br6;
Man6(i,3) = temp_man6;


%CNC7
CNC7(i,1) = cnc7_sum(i);
CNC7(i,2) = cnc_br7;
CNC7(i,3) = temp_cnc7;



%CNC8
CNC8(i,1) = cnc8_sum(i);
CNC8(i,2) = cnc_br8;
CNC8(i,3) = temp_cnc8;


%CNC9
CNC9(i,1) = cnc9_sum(i);
CNC9(i,2) = cnc_br9;
CNC9(i,3) = temp_cnc9;


%MM10
MM10(i,1) = mm10_sum(i);
MM10(i,2) = mm_br10;
MM10(i,3) = temp_mm10;


%MK11
MK11(i,1) = mk11_sum(i);
MK11(i,2) = mk_br11;
MK11(i,3) = temp_mk11;


%QA12
QA12(i,1) = QA_cyc12(i);


%D13
D13(i,1) = dress13_sum(i);
D13(i,2) = dress_br13;
D13(i,3) = temp_dress13;


%QA14
QA14(i,1) = QA_cyc14(i);


%AS15
AS15(i,1) = Assem_cyc15(i);

%DB16
DB16(i,1) = dressbal16_sum(i);
DB16(i,2) = dressbal_br16;
DB16(i,3) = temp_dressbal16;


%DB17
DB17(i,1) = dressbal17_sum(i);
DB17(i,2) = dressbal_br17;
DB17(i,3) = temp_dressbal17;


%QA18
QA18(i,1) = QA_cyc18(i);


%SHI19
SHI19(i,1) = Shi_cyc19(i);

if i > 1

    QA2(i,2) = QA_cyc2_wait_time;
    CNC3(i,4) = cnc3_wait_time;
    CNC4(i,4) = cnc4_wait_time;
    CNC5(i,4) = cnc5_wait_time;
    Man6(i,4) = man6_wait_time;
    CNC7(i,4) = cnc7_wait_time;
    CNC8(i,4) = cnc8_wait_time;
    CNC9(i,4) = cnc9_wait_time;
    MM10(i,4) = mm10_wait_time;
    MK11(i,4) = mk11_wait_time;
    QA12(i,2) = QA_cyc12_wait_time;
    D13(i,4) = dress13_wait_time;
    QA14(i,2) = QA_cyc14_wait_time;
    AS15(i,2) = Assem_cyc15_wait_time;
    DB16(i,4) = dressbal16_wait_time;
    DB17(i,4) = dressbal17_wait_time;
    QA18(i,2) = QA_cyc18_wait_time;
    SHI19(i,2) = Shi_cyc19_wait_time;

end

t(i,1) = rec_cyc1(i)+ QA_cyc2(i) +cnc3_sum(i) + cnc4_sum(i) + cnc5_sum(i) + man6_sum(i)...
      + cnc7_sum(i) + cnc8_sum(i) + cnc9_sum(i)+ mm10_sum(i) + mk11_sum(i) + QA_cyc12(i)...
      + dress13_sum(i) + QA_cyc14(i) + Assem_cyc15(i) + dressbal16_sum(i) + dressbal17_sum(i)...
      + QA_cyc18(i) + Shi_cyc19(i);


end


Cycle_Time = cat(2, REC1(:,1), QA2(:,1), CNC3(:,1), CNC4(:,1), CNC5(:,1), Man6(:,1),...
    CNC7(:,1), CNC8(:,1), CNC9(:,1), MM10(:,1), MK11(:,1), QA12(:,1), D13(:,1),...
    QA14(:,1), AS15(:,1), DB16(:,1), DB17(:,1), QA18(:,1), SHI19(:,1));

Wait_Time = cat(2, QA2(:,2), CNC3(:,4), CNC4(:,4), CNC5(:,4), Man6(:,4),...
    CNC7(:,4), CNC8(:,4), CNC9(:,4), MM10(:,4), MK11(:,4), QA12(:,2), D13(:,4),...
    QA14(:,2), AS15(:,2), DB16(:,4), DB17(:,4), QA18(:,2), SHI19(:,2));

Cycle_Time_Avg = mean(Cycle_Time);


headings_1 = {'REC1', 'QA2', 'CNC3', 'CNC4', 'CNC5', 'Man6', 'CNC7', 'CNC8',...
    'CNC9', 'MM10', 'MK11', 'QA12', 'D13','QA14', 'AS15', 'DB16', 'DB17',...
    'QA18', 'SHI19'};


%Cycle_Time = array2table(Cycle_Time,"VariableNames",headings);

[max_CT, process] = max(Cycle_Time,[],2);


Prod_1_br = cat(2,CNC3(:,2),CNC4(:,2),CNC5(:,2),Man6(:,2),CNC7(:,2),...
    CNC8(:,2),CNC9(:,2),MM10(:,2),MK11(:,2),D13(:,2),DB16(:,2),DB17(:,2));


%CNC3

[Time_CNC3_72,ia_72_CNC3,~] = unique(Prod_1_br(:,1));
ia_72_CNC3 = sort(ia_72_CNC3,'ascend');
CNC3_fail = numel(ia_72_CNC3);

%CNC4
[Time_CNC4_72,ia_72_CNC4,~] = unique(Prod_1_br(:,2));
ia_72_CNC4 = sort(ia_72_CNC4,'ascend');
CNC4_fail = numel(ia_72_CNC4);

%CNC5
[Time_CNC5_72,ia_72_CNC5,~] = unique(Prod_1_br(:,3));
ia_72_CNC5 = sort(ia_72_CNC5,'ascend');
CNC5_fail = numel(ia_72_CNC5);

%Man6
[Time_Man6_72,ia_72_Man6,~] = unique(Prod_1_br(:,4));
ia_72_Man6 = sort(ia_72_Man6,'ascend');
Man6_fail = numel(ia_72_Man6);

%CNC7
[Time_CNC7_72,ia_72_CNC7,~] = unique(Prod_1_br(:,5));
ia_72_CNC7 = sort(ia_72_CNC7,'ascend');
CNC7_fail = numel(ia_72_CNC7);

%CNC8
[Time_CNC8_72,ia_72_CNC8,~] = unique(Prod_1_br(:,6));
ia_72_CNC8 = sort(ia_72_CNC8,'ascend');
CNC8_fail = numel(ia_72_CNC8);

%CNC9
[Time_CNC9_72,ia_72_CNC9,~] = unique(Prod_1_br(:,7));
ia_72_CNC9 = sort(ia_72_CNC9,'ascend');
CNC9_fail = numel(ia_72_CNC9);

%MM10
[Time_MM10_72,ia_72_MM10,~] = unique(Prod_1_br(:,8));
ia_72_MM10 = sort(ia_72_MM10,'ascend');
MM10_fail = numel(ia_72_MM10);

%MK11
[Time_MK11_72,ia_72_MK11,~] = unique(Prod_1_br(:,9));
ia_72_MK11 = sort(ia_72_MK11,'ascend');
MK11_fail = numel(ia_72_MK11);

%D13
[Time_D13_72,ia_72_D13,~] = unique(Prod_1_br(:,10));
ia_72_D13 = sort(ia_72_D13,'ascend');
D13_fail = numel(ia_72_D13);

%DB16
[Time_DB16_72,ia_72_DB16,~] = unique(Prod_1_br(:,11));
ia_72_DB16 = sort(ia_72_DB16,'ascend');
DB16_fail = numel(ia_72_DB16);

%DB17
[Time_DB17_72,ia_72_DB17,~] = unique(Prod_1_br(:,12));
ia_72_DB17 = sort(ia_72_DB17,'ascend');
DB17_fail = numel(ia_72_DB17);



%% Product 2 - 126054

Part2_cyc_std = [Part2.Avg_Hours(:) Part2.Std_Dev_(:)];

[cnc_br3_54,~,cnc_stup3_54] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[cnc_br4_54,~,cnc_stup4_54] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[man_br5_54,~,man_stup5_54] = Man_Sftlth(Man_br_mean,Man_br_std,0,0,Man_stup);

[cnc_br6_54,~,cnc_stup6_54] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[mm_br7_54,~,mm_stup7_54] = Man_Mill(MM_br_mean,MM_br_std,0,0,MM_stup);

[dress_br10_54,~,dress_stup10_54] = Dress(Dress_br_mean,Dress_br_std,0,0,Dress_stup);

[cnc_br12_54,~,cnc_stup12_54] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[dressbal_br13_54,~,dressbal_stup13_54] = Dress_Bal(DB_br_mean,DB_br_std,0,0,DB_stup);

[cnc_br14_54,~,cnc_stup14_54] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);


[temp_cnc3_54, temp_cnc4_54, temp_man5_54, temp_cnc6_54, temp_mm7_54,...
    temp_dress10_54, temp_cnc12_54, temp_dressbal13_54, temp_cnc14_54] = deal(0);


for i = 1:cycles

    rec_cyc1_54(i) = abs(normrnd(2.48,1)); %REC1_54

    QA_cyc2_54(i) = abs(normrnd(7.13,2)); %QA2_54

    if i > 1

        if QA_cyc2_54(i) > rec_cyc1_54(i-1)

            QA2_54_wait_time = QA_cyc2_54(i) - rec_cyc1_54(i-1);

            QA_cyc2_54(i) = QA2_54_wait_time + QA_cyc2_54(i);

        else

            QA2_54_wait_time = 0;

            QA_cyc2_54(i) = QA2_54_wait_time + QA_cyc2_54(i);

        end

    end

    if temp_cnc3_54 >= cnc_br3_54  %CNC3_54


        [cnc_br3_54,cnc_cyc3_54,~] = Cnc_horiz(CNC_br_mean,CNC_br_std,...
            Part2_cyc_std(3,1),Part2_cyc_std(3,2),0);
        
        temp_cnc3_54 = 0;

        cnc3_54_sum(i) = cnc_cyc3_54 + abs(normrnd(6,0.5));

        temp_cnc3_54 = temp_cnc3_54 + cnc3_54_sum(i);

        if i > 1

            if cnc3_54_sum(i) > QA_cyc2_54(i-1)

                cnc3_54_wait_time = cnc3_54_sum(i) - QA_cyc2_54(i-1);

                cnc3_54_sum(i) = cnc3_54_wait_time + cnc_cyc3_54;

            else

                cnc3_54_wait_time = 0;

                cnc3_54_sum(i) = cnc3_54_wait_time + cnc_cyc3_54;
                
            end

        end

    else

        [~,cnc_cyc3_54,~] = Cnc_horiz(0,0,...
            Part2_cyc_std(3,1),Part2_cyc_std(3,2),0);
        
        cnc3_54_sum(i) = cnc_cyc3_54; 

        temp_cnc3_54 = temp_cnc3_54 + cnc3_54_sum(i);

        if i > 1

            if cnc3_54_sum(i) > QA_cyc2_54(i-1)

                cnc3_54_wait_time = cnc3_54_sum(i) - QA_cyc2_54(i-1);

                cnc3_54_sum(i) = cnc3_54_wait_time + cnc_cyc3_54;

            else

                cnc3_54_wait_time = 0;

                cnc3_54_sum(i) = cnc3_54_wait_time + cnc_cyc3_54;
                
            end

        end
        

    end

    if temp_cnc4_54 >= cnc_br4_54     %CNC4_54
        
        [cnc_br4_54,cnc_cyc4_54,~] = Cnc_horiz(CNC_br_mean,CNC_br_std,...
            Part2_cyc_std(4,1),Part2_cyc_std(4,2),0);
        
        temp_cnc4_54 = 0;

        cnc4_54_sum(i) = cnc_cyc4_54 + abs(normrnd(6,0.5));

        temp_cnc4_54 = temp_cnc4_54 + cnc4_54_sum(i);

        if i > 1

            if cnc4_54_sum(i) > cnc3_54_sum(i-1)

                cnc4_54_wait_time = cnc4_54_sum(i) - cnc3_54_sum(i-1);

                cnc4_54_sum(i) = cnc_cyc4_54 + cnc4_54_wait_time;               

            else

                cnc4_54_wait_time = 0;

                cnc4_54_sum(i) = cnc_cyc4_54 + cnc4_54_wait_time;

            end

        end


    else
        
        [~,cnc_cyc4_54,~] = Cnc_horiz(0,0,...
            Part2_cyc_std(4,1),Part2_cyc_std(4,2),0);
        
        cnc4_54_sum(i) = cnc_cyc4_54; 

        temp_cnc4_54 = temp_cnc4_54 + cnc4_54_sum(i);

        if i > 1

            if cnc4_54_sum(i) > cnc3_54_sum(i-1)

                cnc4_54_wait_time = cnc4_54_sum(i) - cnc3_54_sum(i-1);

                cnc4_54_sum(i) = cnc_cyc4_54 + cnc4_54_wait_time;               

            else

                cnc4_54_wait_time = 0;

                cnc4_54_sum(i) = cnc_cyc4_54 + cnc4_54_wait_time;

            end

        end        

    end

    if temp_man5_54 >= man_br5_54  %MAN5_54

        [man_br5_54,man_cyc5_54,~] = Man_Sftlth(Man_br_mean,Man_br_std,...
            Part2_cyc_std(5,1),Part2_cyc_std(5,2),0);
        
        temp_man5_54 = 0;

        man5_sum_54(i) = man_cyc5_54 + abs(normrnd(6,0.5));

        temp_man5_54 = temp_man5_54 + man5_sum_54(i);

        if i > 1

            if man5_sum_54(i) > cnc4_54_sum(i-1)

                man5_54_wait_time = man5_sum_54(i) - cnc4_54_sum(i-1);                

                man5_sum_54(i) = man_cyc5_54 + man5_54_wait_time;

            else                

                man5_54_wait_time = 0;

                man5_sum_54(i) = man_cyc5_54 + man5_54_wait_time;

            end

        end

    else
        
       [~,man_cyc5_54,~] = Man_Sftlth(0,0,...
            Part2_cyc_std(5,1),Part2_cyc_std(5,2),0);
        
        man5_sum_54(i) = man_cyc5_54; 

        temp_man5_54 = temp_man5_54 + man5_sum_54(i);

        if i > 1

            if man5_sum_54(i) > cnc4_54_sum(i-1)

                man5_54_wait_time = man5_sum_54(i) - cnc4_54_sum(i-1);

                man5_sum_54(i) = man_cyc5_54 + man5_54_wait_time;

            else

                man5_54_wait_time = 0;

                man5_sum_54(i) = man_cyc5_54 + man5_54_wait_time;

            end

        end

    end


    if temp_cnc6_54 >= cnc_br6_54  %CNC6_54

        [cnc_br6_54,cnc_cyc6_54,~] = Cnc_horiz(CNC_br_mean,CNC_br_std,...
            Part2_cyc_std(6,1),Part2_cyc_std(6,2),0);
        
        temp_cnc6_54 = 0;

        cnc6_54_sum(i) = cnc_cyc6_54 + abs(normrnd(6,0.5));

        temp_cnc6_54 = temp_cnc6_54 + cnc6_54_sum(i);

        if i > 1

            if cnc6_54_sum(i) >  man5_sum_54(i-1)

                cnc6_54_wait_time = cnc6_54_sum(i) - man5_sum_54(i-1);
                
                cnc6_54_sum(i) = cnc_cyc6_54 + cnc6_54_wait_time;

            else

                cnc6_54_wait_time = 0;

                cnc6_54_sum(i) = cnc_cyc6_54 + cnc6_54_wait_time;

            end

        end

    else

        [~,cnc_cyc6_54,~] = Cnc_horiz(0,0,...
            Part2_cyc_std(6,1),Part2_cyc_std(6,2),0);
        
        cnc6_54_sum(i) = cnc_cyc6_54; 

        temp_cnc6_54 = temp_cnc6_54 + cnc6_54_sum(i);

        if i > 1

            if cnc6_54_sum(i) >  man5_sum_54(i-1)

                cnc6_54_wait_time = cnc6_54_sum(i) - man5_sum_54(i-1);

                cnc6_54_sum(i) = cnc_cyc6_54 + cnc6_54_wait_time;

            else

                cnc6_54_wait_time = 0;

                cnc6_54_sum(i) = cnc_cyc6_54 + cnc6_54_wait_time;

            end

        end

    end
    
    if temp_mm7_54 >= mm_br7_54  %MM7_54

        [mm_br7_54,mm_cyc7_54,~] = Man_Mill(MM_br_mean,MM_br_std,...
            Part2_cyc_std(7,1),Part2_cyc_std(7,2),0);

        temp_mm7_54 = 0;

        mm7_54_sum(i) = mm_cyc7_54 + normrnd(6,0.5);

        temp_mm7_54 = temp_mm7_54 + mm7_54_sum(i);

        if i > 1

            if mm7_54_sum(i) > cnc6_54_sum(i-1)

                mm7_54_wait_time = mm7_54_sum(i) - cnc6_54_sum(i-1);

                mm7_54_sum(i) = mm7_54_wait_time + mm_cyc7_54;

            else

                mm7_54_wait_time = 0;

                mm7_54_sum(i) = mm7_54_wait_time + mm_cyc7_54;

            end

        end

    else

        [~,mm_cyc7_54,~] = Man_Mill(0,0,...
            Part2_cyc_std(7,1),Part2_cyc_std(7,2),0);
        
        mm7_54_sum(i) = mm_cyc7_54;

        temp_mm7_54 = temp_mm7_54 + mm7_54_sum(i);

        if i > 1

            if mm7_54_sum(i) > cnc6_54_sum(i-1)

                mm7_54_wait_time = mm7_54_sum(i) - cnc6_54_sum(i-1);

                mm7_54_sum(i) = mm7_54_wait_time + mm_cyc7_54;

            else

                mm7_54_wait_time = 0;

                mm7_54_sum(i) = mm7_54_wait_time + mm_cyc7_54;

            end

        end
    
    end

    OSP_cyc8_54(i) = abs(normrnd(0.91,1));  %OSP8_54

    if i > 1

        if OSP_cyc8_54(i) > mm7_54_sum(i-1)
    
            OSP8_54_wait_time = OSP_cyc8_54(i) - mm7_54_sum(i-1);

            OSP_cyc8_54(i) = OSP_cyc8_54(i) + OSP8_54_wait_time;

        else

            OSP8_54_wait_time = 0;

            OSP_cyc8_54(i) = OSP_cyc8_54(i) + OSP8_54_wait_time;

        end

    end


    QA_cyc9_54(i) = abs(normrnd(5.67,2));  %QA9_54

    if i > 1

        if QA_cyc9_54(i) > OSP_cyc8_54(i-1)

            QA9_54_wait_time = QA_cyc9_54(i) - OSP_cyc8_54(i-1);

            QA_cyc9_54(i) = QA9_54_wait_time + QA_cyc9_54(i);

        else

            QA9_54_wait_time = 0;

            QA_cyc9_54(i) = QA9_54_wait_time + QA_cyc9_54(i);

        end

    end
    
    if temp_dress10_54 >= dress_br10_54  %D10_54


        [dress_br10_54,dress_cyc10_54,~] = Dress(Dress_br_mean,Dress_br_std, ...
            Part2_cyc_std(10,1),Part2_cyc_std(10,2),0);

        temp_dress10_54 = 0;

        dress10_54_sum(i) = dress_cyc10_54 + abs(normrnd(6,0.5));

        temp_dress10_54 = temp_dress10_54 + dress10_54_sum(i);

        if i > 1

            if dress10_54_sum(i) > QA_cyc9_54(i-1)

                dress10_54_wait_time = dress10_54_sum(i) - QA_cyc9_54(i-1);

                dress10_54_sum(i) = dress_cyc10_54 + dress10_54_wait_time;

            else

                dress10_54_wait_time = 0;

                dress10_54_sum(i) = dress_cyc10_54 + dress10_54_wait_time;

            end

        end


    else

        
        [~,dress_cyc10_54,~] = Dress(0,0, ...
            Part2_cyc_std(10,1),Part2_cyc_std(10,2),0);
        
        dress10_54_sum(i) = dress_cyc10_54;

        temp_dress10_54 = temp_dress10_54 + dress10_54_sum(i);

        if i > 1

            if dress10_54_sum(i) > QA_cyc9_54(i-1)

                dress10_54_wait_time = dress10_54_sum(i) - QA_cyc9_54(i-1);

                dress10_54_sum(i) = dress_cyc10_54 + dress10_54_wait_time;

            else

                dress10_54_wait_time = 0;

                dress10_54_sum(i) = dress_cyc10_54 + dress10_54_wait_time;

            end

        end

    end

    QA_cyc11_54(i) = abs(normrnd(3.51,2));  %QA11_54

    if i > 1

        if QA_cyc11_54(i) > dress10_54_sum(i-1)

            QA11_54_wait_time = QA_cyc11_54(i) - dress10_54_sum(i-1);

            QA_cyc11_54(i) = QA_cyc11_54(i) + QA11_54_wait_time;

        else

            QA11_54_wait_time = 0;

            QA_cyc11_54(i) = QA_cyc11_54(i) + QA11_54_wait_time;

        end

    end

    if temp_cnc12_54 >= cnc_br12_54  %CNC12_54

        [cnc_br12_54,cnc_cyc12_54,~] = Cnc_horiz(CNC_br_mean,CNC_br_std, ...
            Part2_cyc_std(12,1),Part2_cyc_std(12,2),0);

        temp_cnc12_54 = 0;

        cnc12_54_sum(i) = cnc_cyc12_54 + abs(normrnd(6,0.5));

        temp_cnc12_54 = temp_cnc12_54 + cnc12_54_sum(i);

        if i > 1

            if cnc12_54_sum(i) > QA_cyc11_54(i-1)

                cnc12_54_wait_time = cnc12_54_sum(i) - QA_cyc11_54(i-1);

                cnc12_54_sum(i) = cnc_cyc12_54 + cnc12_54_wait_time;

            else
                
                cnc12_54_wait_time = 0;

                cnc12_54_sum(i) = cnc_cyc12_54 + cnc12_54_wait_time;

            end

        end

    else

        [~,cnc_cyc12_54,~] = Cnc_horiz(0,0, ...
            Part2_cyc_std(12,1),Part2_cyc_std(12,2),0);
        
        cnc12_54_sum(i) = cnc_cyc12_54; 

        temp_cnc12_54 = temp_cnc12_54 + cnc12_54_sum(i);

        if i > 1

            if cnc12_54_sum(i) > QA_cyc11_54(i-1)

                cnc12_54_wait_time = cnc12_54_sum(i) - QA_cyc11_54(i-1);                

                cnc12_54_sum(i) = cnc_cyc12_54 + cnc12_54_wait_time;

            else
                
                cnc12_54_wait_time = 0;

                cnc12_54_sum(i) = cnc_cyc12_54 + cnc12_54_wait_time;

            end

        end

    end
    
    if temp_dressbal13_54 >= dressbal_br13_54  %DB13_54

        [dressbal_br13_54,dressbal_cyc13_54,~] = Dress_Bal(DB_br_mean,DB_br_std, ...
            Part2_cyc_std(13,1),Part2_cyc_std(13,2),0);
        
        temp_dressbal13_54 = 0;
        
        dressbal13_54_sum(i) = dressbal_cyc13_54 + abs(normrnd(6,0.5));

        temp_dressbal13_54 = temp_dressbal13_54 + dressbal13_54_sum(i);

        if i > 1

            if dressbal13_54_sum(i) > cnc12_54_sum(i-1)

                dressbal13_54_wait_time = dressbal13_54_sum(i) - cnc12_54_sum(i-1);

                dressbal13_54_sum(i) = dressbal_cyc13_54 + dressbal13_54_wait_time;

            else

                dressbal13_54_wait_time = 0;

                dressbal13_54_sum(i) = dressbal_cyc13_54 + dressbal13_54_wait_time;

            end

        end

    else

        [~,dressbal_cyc13_54,~] = Dress_Bal(0,0, ...
            Part2_cyc_std(13,1),Part2_cyc_std(13,2),0);
        
        dressbal13_54_sum(i) = dressbal_cyc13_54;

        temp_dressbal13_54 = temp_dressbal13_54 + dressbal13_54_sum(i);

        if i > 1

            if dressbal13_54_sum(i) > cnc12_54_sum(i-1)

                dressbal13_54_wait_time = dressbal13_54_sum(i) - cnc12_54_sum(i-1);

                dressbal13_54_sum(i) = dressbal_cyc13_54 + dressbal13_54_wait_time;

            else

                dressbal13_54_wait_time = 0;

                dressbal13_54_sum(i) = dressbal_cyc13_54 + dressbal13_54_wait_time;

            end

        end

    end


    if temp_cnc14_54 >= cnc_br14_54  %CNC14_54


        [cnc_br14_54,cnc_cyc14_54,~] = Cnc_horiz(CNC_br_mean,CNC_br_std, ...
            Part2_cyc_std(14,1),Part2_cyc_std(14,2),0);

        temp_cnc14_54 = 0;

        cnc14_54_sum(i) = cnc_cyc14_54 + abs(normrnd(6,0.5));

        temp_cnc14_54 = temp_cnc14_54 + cnc14_54_sum(i);

        if i > 1

            if cnc14_54_sum(i) > dressbal13_54_sum(i-1)

                cnc14_54_wait_time = cnc14_54_sum(i) - dressbal13_54_sum(i-1);

                cnc14_54_sum(i) = cnc_cyc14_54 + cnc14_54_wait_time;

            else

                cnc14_54_wait_time = 0;

                cnc14_54_sum(i) = cnc_cyc14_54 + cnc14_54_wait_time;

            end

        end               

    else        

        
        [~,cnc_cyc14_54,~] = Cnc_horiz(0,0, ...
            Part2_cyc_std(14,1),Part2_cyc_std(14,2),0);
        
        cnc14_54_sum(i) = cnc_cyc14_54; 

        temp_cnc14_54 = temp_cnc14_54 + cnc14_54_sum(i);

        if i > 1

            if cnc14_54_sum(i) > dressbal13_54_sum(i-1)

                cnc14_54_wait_time = cnc14_54_sum(i) - dressbal13_54_sum(i-1);

                cnc14_54_sum(i) = cnc_cyc14_54 + cnc14_54_wait_time;

            else

                cnc14_54_wait_time = 0;

                cnc14_54_sum(i) = cnc_cyc14_54 + cnc14_54_wait_time;

            end

        end 

    end

    QA_cyc15_54(i) = abs(normrnd(5.88,2));  %QA15_54

    if i > 1

        if QA_cyc15_54(i) > cnc14_54_sum(i-1)
    
            QA15_54_wait_time = QA_cyc15_54(i) - cnc14_54_sum(i-1);
    
            QA_cyc15_54(i) = QA15_54_wait_time + QA_cyc15_54(i);
    
        else
    
            QA15_54_wait_time = 0;

            QA_cyc15_54(i) = QA15_54_wait_time + QA_cyc15_54(i);
    
        end

    end

    Shi_cyc16_54(i) = abs(normrnd(3.19,0.75)); %SHI16

    if i > 1

        if Shi_cyc16_54(i) > QA_cyc15_54(i-1)
    
            Shi16_54_wait_time = Shi_cyc16_54(i) - QA_cyc15_54(i-1);
    
            Shi_cyc16_54(i) = Shi_cyc16_54(i) + Shi16_54_wait_time;
    
        else
    
            Shi16_54_wait_time = 0;

            Shi_cyc16_54(i) = Shi_cyc16_54(i) + Shi16_54_wait_time;
    
        end

    end


    REC1_54(i,1) = rec_cyc1_54(i);

    QA2_54(i,1) = QA_cyc2_54(i);

    CNC3_54(i,1) = cnc3_54_sum(i);
    CNC3_54(i,2) = cnc_br3_54;
    CNC3_54(i,3) = temp_cnc3_54;

    CNC4_54(i,1) = cnc4_54_sum(i);
    CNC4_54(i,2) = cnc_br4_54;
    CNC4_54(i,3) = temp_cnc4_54;

    MAN5_54(i,1) = man5_sum_54(i);
    MAN5_54(i,2) = man_br5_54;
    MAN5_54(i,3) = temp_man5_54;

    CNC6_54(i,1) = cnc6_54_sum(i);
    CNC6_54(i,2) = cnc_br6_54;
    CNC6_54(i,3) = temp_cnc6_54;

    MM7_54(i,1) = mm7_54_sum(i);
    MM7_54(i,2) = mm_br7_54;
    MM7_54(i,3) = temp_mm7_54;

    OSP8_54(i,1) = OSP_cyc8_54(i);

    QA9_54(i,1) = QA_cyc9_54(i);

    D10_54(i,1) = dress10_54_sum(i);
    D10_54(i,2) = dress_br10_54;
    D10_54(i,3) = temp_dress10_54;

    QA11_54(i,1) = QA_cyc11_54(i);

    CNC12_54(i,1) = cnc12_54_sum(i);
    CNC12_54(i,2) = cnc_br12_54;
    CNC12_54(i,3) = temp_cnc12_54;

    DB13_54(i,1) = dressbal13_54_sum(i);
    DB13_54(i,2) = dressbal_br13_54;
    DB13_54(i,3) = temp_dressbal13_54;

    CNC14_54(i,1) = cnc14_54_sum(i);
    CNC14_54(i,2) = cnc_br14_54;
    CNC14_54(i,3) = temp_cnc14_54;

    QA15_54(i,1) = QA_cyc15_54(i);

    SHI16_54(i,1) = Shi_cyc16_54(i);

    if i > 1

        QA2_54(i,2) = QA2_54_wait_time;
        CNC3_54(i,4) = cnc3_54_wait_time;
        CNC4_54(i,4) = cnc4_54_wait_time;
        MAN5_54(i,4) = man5_54_wait_time;
        CNC6_54(i,4) = cnc6_54_wait_time;
        MM7_54(i,4) = mm7_54_wait_time;
        OSP8_54(i,2) = OSP8_54_wait_time;
        QA9_54(i,2) = QA9_54_wait_time;
        D10_54(i,4) = dress10_54_wait_time;
        QA11_54(i,2) = QA11_54_wait_time;
        CNC12_54(i,4) = cnc12_54_wait_time;
        DB13_54(i,4) = dressbal13_54_wait_time;
        CNC14_54(i,4) = cnc14_54_wait_time;
        QA15_54(i,2) = QA15_54_wait_time;
        SHI16_54(i,2) = Shi16_54_wait_time;

    end

    t_54(i,1) = rec_cyc1_54(i) + QA_cyc2_54(i) + cnc3_54_sum(i) + cnc4_54_sum(i) +...
        man5_sum_54(i) + cnc6_54_sum(i) + mm7_54_sum(i) + OSP_cyc8_54(i) + QA_cyc9_54(i) +...
        dress10_54_sum(i) + QA_cyc11_54(i) + cnc12_54_sum(i) + dressbal13_54_sum(i) +...
        cnc14_54_sum(i) + QA_cyc15_54(i) + Shi_cyc16_54(i);

end


Cycle_Time_54 = cat(2,REC1_54(:,1), QA2_54(:,1), CNC3_54(:,1), CNC4_54(:,1), MAN5_54(:,1),...
    CNC6_54(:,1), MM7_54(:,1), OSP8_54(:,1), QA9_54(:,1), D10_54(:,1), QA11_54(:,1),...
    CNC12_54(:,1), DB13_54(:,1), CNC14_54(:,1), QA15_54(:,1), SHI16_54(:,1));

Wait_Time_54 = cat(2,QA2_54(:,2), CNC3_54(:,4), CNC4_54(:,4), MAN5_54(:,4),...
    CNC6_54(:,4), MM7_54(:,4), OSP8_54(:,2), QA9_54(:,2), D10_54(:,4), QA11_54(:,2),...
    CNC12_54(:,4), DB13_54(:,4), CNC14_54(:,4), QA15_54(:,2), SHI16_54(:,2));

Cycle_Time_54_Avg = mean(Cycle_Time_54);

[max_CT_54, process_54] = max(Cycle_Time_54,[],2);

Prod_2_br = cat(2, CNC3_54(:,2),CNC4_54(:,2), MAN5_54(:,2),CNC6_54(:,2), ...
    MM7_54(:,2), D10_54(:,2),CNC12_54(:,2), DB13_54(:,2), CNC14_54(:,2));

%CNC3_54

[Time_CNC3_54,ia_54_CNC3,~] = unique(Prod_2_br(:,1));
ia_54_CNC3 = sort(ia_54_CNC3,'ascend');
CNC3_54_fail = numel(ia_54_CNC3);

%CNC4_54

[Time_CNC4_54,ia_54_CNC4,~] = unique(Prod_2_br(:,2));
ia_54_CNC4 = sort(ia_54_CNC4,'ascend');
CNC4_54_fail = numel(ia_54_CNC4);

%MAN5_54

[Time_MAN5_54,ia_54_MAN5,~] = unique(Prod_2_br(:,3));
ia_54_MAN5 = sort(ia_54_MAN5,'ascend');
MAN5_54_fail = numel(ia_54_MAN5);

%CNC6_54

[Time_CNC6_54,ia_54_CNC6,~] = unique(Prod_2_br(:,4));
ia_54_CNC6 = sort(ia_54_CNC6,'ascend');
CNC6_54_fail = numel(ia_54_CNC6);

%MM7_54

[Time_MM7_54,ia_54_MM7,~] = unique(Prod_2_br(:,5));
ia_54_MM7 = sort(ia_54_MM7,'ascend');
MM7_54_fail = numel(ia_54_MM7);

%D10_54

[Time_D10_54,ia_54_D10,~] = unique(Prod_2_br(:,6));
ia_54_D10 = sort(ia_54_D10,'ascend');
D10_54_fail = numel(ia_54_D10);

%CNC12_54
[Time_CNC12_54,ia_54_CNC12,~] = unique(Prod_2_br(:,7));
ia_54_CNC12 = sort(ia_54_CNC12,'ascend');
CNC12_54_fail = numel(ia_54_CNC12);

%DB13_54
[Time_DB13_54,ia_54_DB13,~] = unique(Prod_2_br(:,8));
ia_54_DB13 = sort(ia_54_DB13,'ascend');
DB13_54_fail = numel(ia_54_DB13);

%CNC14_54
[Time_CNC14_54,ia_54_CNC14,~] = unique(Prod_2_br(:,9));
ia_54_CNC14 = sort(ia_54_CNC14,'ascend');
CNC14_54_fail = numel(ia_54_CNC14);

%%
% Product 3 - 126293

Part3_cyc_std = [Part3.Avg_Hours(:), Part3.Std_Dev_(:)];

[cnc_br3_93, ~, cnc_stup3_93] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[cnc_br4_93, ~, cnc_stup4_93] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[mm_br5_93, ~, mm_stup5_93] = Man_Mill(Man_br_mean,Man_br_std,0,0,Man_stup);

[mk_br6_93, ~, mk_stup6_93] = Man_Key(MK_br_mean,MK_br_std,0,0,MK_stup);

[dress_br7_93, ~, dress_stup7_93] = Dress(Dress_br_mean,Dress_br_std,0,0,Dress_stup);

[dressbal_br8_93, ~, dressbal_stup8_93] = Dress_Bal(DB_br_mean,DB_br_std,0,0,DB_stup);

[test_br9_93, ~, test_stup9_93] = Testing(Test_br_mean, Test_br_std,0,0,Test_stup);


[temp_cnc3_93, temp_cnc4_93, temp_mm5_93, temp_mk6_93, temp_dress7_93,...
    temp_db8_93, temp_test9_93] = deal(0);

for i = 1:cycles

REC_cyc1_93(i) = abs(normrnd(2.01,1));

QA_cyc2_93(i) = abs(normrnd(5.63,1.5));

if i > 1

    if QA_cyc2_93(i) > REC_cyc1_93(i-1)

        QA2_93_wait_time = QA_cyc2_93(i) - REC_cyc1_93(i-1);

        QA_cyc2_93(i) = QA2_93_wait_time + abs(normrnd(5.63,1.5));

    else

        QA2_93_wait_time = 0;

        QA_cyc2_93(i) = QA2_93_wait_time + abs(normrnd(5.63,1.5));

    end

end

if temp_cnc3_93 >= cnc_br3_93

    [cnc_br3_93, cnc_cyc3_93, ~] = Cnc_horiz(CNC_br_mean,CNC_br_std, ...
        Part3_cyc_std(3,1),Part3_cyc_std(3,2),0);

    temp_cnc3_93 = 0;

    cnc3_93_sum(i) = cnc_cyc3_93 + abs(normrnd(6,0.5));

    temp_cnc3_93 = temp_cnc3_93 + cnc3_93_sum(i);

    if i > 1

        if cnc3_93_sum(i) > QA_cyc2_93(i-1)

            cnc3_93_wait_time = cnc3_93_sum(i) - QA_cyc2_93(i-1);

            cnc3_93_sum(i) = cnc3_93_wait_time + cnc_cyc3_93;

        else

            cnc3_93_wait_time = 0;

             cnc3_93_sum(i) = cnc3_93_wait_time + cnc_cyc3_93;

        end

    end

else

    [~, cnc_cyc3_93, ~] = Cnc_horiz(0,0,Part3_cyc_std(3,1),Part3_cyc_std(3,2),0);

    cnc3_93_sum(i) = cnc_cyc3_93;

    temp_cnc3_93 = temp_cnc3_93 + cnc3_93_sum(i);

    if i > 1

        if cnc3_93_sum(i) > QA_cyc2_93(i-1)

            cnc3_93_wait_time = cnc3_93_sum(i) - QA_cyc2_93(i-1);

            cnc3_93_sum(i) = cnc3_93_wait_time + cnc_cyc3_93;

        else

            cnc3_93_wait_time = 0;

             cnc3_93_sum(i) = cnc3_93_wait_time + cnc_cyc3_93;

        end

    end

end

if temp_cnc4_93 >= cnc_br4_93

    [cnc_br4_93, cnc_cyc4_93, ~] = Cnc_horiz(CNC_br_mean,CNC_br_std, ...
        Part3_cyc_std(4,1),Part3_cyc_std(4,2),0);

    temp_cnc4_93 = 0;

    cnc4_93_sum(i) = cnc_cyc4_93 + abs(normrnd(6,0.5));

    temp_cnc4_93 = temp_cnc4_93 + cnc4_93_sum(i);

    if i > 1

        if cnc4_93_sum(i) > cnc3_93_sum(i-1)

            cnc4_93_wait_time = cnc4_93_sum(i) - cnc3_93_sum(i-1);

            cnc4_93_sum(i) = cnc4_93_wait_time + cnc_cyc4_93;

        else

            cnc4_93_wait_time = 0;

            cnc4_93_sum(i) = cnc4_93_wait_time + cnc_cyc4_93;

        end

    end

else

    [~, cnc_cyc4_93, ~] = Cnc_horiz(0,0,Part3_cyc_std(4,1),Part3_cyc_std(4,2),0);

    cnc4_93_sum(i) = cnc_cyc4_93;

    temp_cnc4_93 = temp_cnc4_93 + cnc4_93_sum(i);

    if i > 1

        if cnc4_93_sum(i) > cnc3_93_sum(i-1)

            cnc4_93_wait_time = cnc4_93_sum(i) - cnc3_93_sum(i-1);

            cnc4_93_sum(i) = cnc4_93_wait_time + cnc_cyc4_93;

        else

            cnc4_93_wait_time = 0;

            cnc4_93_sum(i) = cnc4_93_wait_time + cnc_cyc4_93;

        end

    end

end

if temp_mm5_93 >= mm_br5_93

    [mm_br5_93,mm_cyc5_93,~] = Man_Mill(MM_br_mean,MM_br_std,Part3_cyc_std(5,1), ...
        Part3_cyc_std(5,2),0);

    temp_mm5_93 = 0;

    mm5_93_sum(i) = mm_cyc5_93 + abs(normrnd(6,0.5));

    temp_mm5_93 = temp_mm5_93 + mm5_93_sum(i);

    if i > 1

        if mm5_93_sum(i) > cnc4_93_sum(i-1)

            mm5_93_wait_time = mm5_93_sum(i) - cnc4_93_sum(i-1);

            mm5_93_sum(i) = mm5_93_wait_time + mm_cyc5_93;

        else

            mm5_93_wait_time = 0;

            mm5_93_sum(i) = mm5_93_wait_time + mm_cyc5_93;

        end

    end

else

    [~,mm_cyc5_93,~] = Man_Mill(0,0,Part3_cyc_std(5,1),Part3_cyc_std(5,2),0);

    mm5_93_sum(i) = mm_cyc5_93;

    temp_mm5_93 = temp_mm5_93 + mm5_93_sum(i);

    if i > 1

        if mm5_93_sum(i) > cnc4_93_sum(i-1)

            mm5_93_wait_time = mm5_93_sum(i) - cnc4_93_sum(i-1);

            mm5_93_sum(i) = mm5_93_wait_time + mm_cyc5_93;

        else

            mm5_93_wait_time = 0;

            mm5_93_sum(i) = mm5_93_wait_time + mm_cyc5_93;

        end

    end

end

if temp_mk6_93 >= mk_br6_93

    [mk_br6_93,mk_cyc6_93,~] = Man_Key(MK_br_mean,MK_br_std,Part3_cyc_std(6,1), ...
        Part3_cyc_std(6,2),0);

    temp_mk6_93 = 0;

    mk6_93_sum(i) = mk_cyc6_93 + abs(normrnd(6,0.5));

    temp_mk6_93 = temp_mk6_93 + mk6_93_sum(i);

    if i > 1

        if mk6_93_sum(i) > mm5_93_sum(i-1)

            mk6_93_wait_time = mk6_93_sum(i) - mm5_93_sum(i-1);

            mk6_93_sum(i) = mk6_93_wait_time + mk_cyc6_93;

        else

            mk6_93_wait_time = 0;

            mk6_93_sum(i) = mk6_93_wait_time + mk_cyc6_93;

        end

    end

else

    [~,mk_cyc6_93,~] = Man_Key(0,0,Part3_cyc_std(6,1),Part3_cyc_std(6,2),0);

    mk6_93_sum(i) = mk_cyc6_93;

    temp_mk6_93 = temp_mk6_93 + mk6_93_sum(i);

    if i > 1

        if mk6_93_sum(i) > mm5_93_sum(i-1)

            mk6_93_wait_time = mk6_93_sum(i) - mm5_93_sum(i-1);

            mk6_93_sum(i) = mk6_93_wait_time + mk_cyc6_93;

        else

            mk6_93_wait_time = 0;

            mk6_93_sum(i) = mk6_93_wait_time + mk_cyc6_93;

        end

    end

end

if temp_dress7_93 >= dress_br7_93

    [dress_br7_93,dress_cyc7_93,~] = Dress(Dress_br_mean, Dress_br_std, ...
        Part3_cyc_std(7,1), Part3_cyc_std(7,2),0);

    temp_dress7_93 = 0;

    dress7_93_sum(i) = dress_cyc7_93 + abs(normrnd(6,0.5));

    temp_dress7_93 = temp_dress7_93 + dress7_93_sum(i);

    if i > 1

        if dress7_93_sum(i) > mk6_93_sum(i-1)

            dress7_93_wait_time = dress7_93_sum(i) - mk6_93_sum(i-1);

            dress7_93_sum(i) = dress7_93_wait_time + dress_cyc7_93;

        else

            dress7_93_wait_time = 0;

            dress7_93_sum(i) = dress7_93_wait_time + dress_cyc7_93;

        end

    end

else

    [~,dress_cyc7_93,~] = Dress(0, 0, Part3_cyc_std(7,1), Part3_cyc_std(7,2),0);

    dress7_93_sum(i) = dress_cyc7_93;

    temp_dress7_93 = temp_dress7_93 + dress7_93_sum(i);

    if i > 1

        if dress7_93_sum(i) > mk6_93_sum(i-1)

            dress7_93_wait_time = dress7_93_sum(i) - mk6_93_sum(i-1);

            dress7_93_sum(i) = dress7_93_wait_time + dress_cyc7_93;

        else

            dress7_93_wait_time = 0;

            dress7_93_sum(i) = dress7_93_wait_time + dress_cyc7_93;

        end

    end    

end

if temp_db8_93 >= dressbal_br8_93

    [dressbal_br8_93, dressbal_cyc8_93,~] = Dress_Bal(DB_br_mean, DB_br_std, ...
        Part3_cyc_std(8,1), Part3_cyc_std(8,2), 0);

    temp_db8_93 = 0;

    db8_93_sum(i) = dressbal_cyc8_93 + normrnd(6,0.5);

    temp_db8_93 = temp_db8_93 + db8_93_sum(i);

    if i > 1

        if db8_93_sum(i) > dress7_93_sum(i-1)

            db8_93_wait_time = db8_93_sum(i) - dress7_93_sum(i-1);

            db8_93_sum(i) = db8_93_wait_time + dressbal_cyc8_93;

        else

            db8_93_wait_time = 0;

            db8_93_sum(i) = db8_93_wait_time + dressbal_cyc8_93;

        end

    end

else

    [~,dressbal_cyc8_93,~] = Dress_Bal(0, 0,Part3_cyc_std(8,1), Part3_cyc_std(8,2),0);

    db8_93_sum(i) = dressbal_cyc8_93;

    temp_db8_93 = temp_db8_93 + db8_93_sum(i);

    if i > 1

        if db8_93_sum(i) > dress7_93_sum(i-1)

            db8_93_wait_time = db8_93_sum(i) - dress7_93_sum(i-1);

            db8_93_sum(i) = db8_93_wait_time + dressbal_cyc8_93;

        else

            db8_93_wait_time = 0;

            db8_93_sum(i) = db8_93_wait_time + dressbal_cyc8_93;

        end

    end

end

if temp_test9_93 >= test_br9_93

    [test_br9_93,test_cyc9_93,~] = Testing(Test_br_mean,Test_br_std, ...
        Part3_cyc_std(9,1),Part3_cyc_std(9,2),0);

    temp_test9_93 = 0;

    test9_93_sum(i) = test_cyc9_93 + abs(norm(6,0.5));

    temp_test9_93 = temp_test9_93 + test9_93_sum(i);

    if i > 1

        if test9_93_sum(i) > db8_93_sum(i-1)

            test9_93_wait_time = test9_93_sum(i) - db8_93_sum(i-1);

            test9_93_sum(i) = test9_93_wait_time + test_cyc9_93;

        else

            test9_93_wait_time = 0;

            test9_93_sum(i) = test9_93_wait_time + test_cyc9_93;

        end

    end

else

    [~,test_cyc9_93,~] = Testing(0,0, ...
        Part3_cyc_std(9,1),Part3_cyc_std(9,2),0);

    test9_93_sum(i) = test_cyc9_93;

    temp_test9_93 = temp_test9_93 + test9_93_sum(i);

    if i > 1

        if test9_93_sum(i) > db8_93_sum(i-1)

            test9_93_wait_time = test9_93_sum(i) - db8_93_sum(i-1);

            test9_93_sum(i) = test9_93_wait_time + test_cyc9_93;

        else

            test9_93_wait_time = 0;

            test9_93_sum(i) = test9_93_wait_time + test_cyc9_93;

        end

    end

end

QA_cyc10_93(i) = abs(normrnd(4.21,1.5));

if i > 1

    if QA_cyc10_93(i) > test9_93_sum(i-1)

        QA10_93_wait_time = QA_cyc10_93(i) - test9_93_sum(i-1);

        QA_cyc10_93(i) = QA10_93_wait_time + abs(normrnd(4.21,1.5));

    else

        QA10_93_wait_time = 0;

        QA_cyc10_93(i) = QA10_93_wait_time + abs(normrnd(4.21,1.5));

    end

end      

Shi_cyc11_93(i) = abs(normrnd(1.66,0.75));

if i > 1 

    if Shi_cyc11_93(i) > QA_cyc10_93(i-1)

        Shi11_93_wait_time = Shi_cyc11_93(i) - QA_cyc10_93(i-1);

        Shi_cyc11_93(i) = Shi11_93_wait_time + abs(normrnd(1.66,0.75));

    else

        Shi11_93_wait_time = 0;

        Shi_cyc11_93(i) = Shi11_93_wait_time + abs(normrnd(1.66,0.75));

    end

end


REC1_93(i,1) = REC_cyc1_93(i);

QA2_93(i,1) = QA_cyc2_93(i);


CNC3_93(i,1) = cnc3_93_sum(i);
CNC3_93(i,2) = cnc_br3_93;
CNC3_93(i,3) = temp_cnc3_93;

CNC4_93(i,1) = cnc4_93_sum(i);
CNC4_93(i,2) = cnc_br4_93;
CNC4_93(i,3) = temp_cnc4_93;

MM5_93(i,1) = mm5_93_sum(i);
MM5_93(i,2) = mm_br5_93;
MM5_93(i,3) = temp_mm5_93;

MK6_93(i,1) = mk6_93_sum(i);
MK6_93(i,2) = mk_br6_93;
MK6_93(i,3) = temp_mk6_93;

D7_93(i,1) = dress7_93_sum(i);
D7_93(i,2) = dress_br7_93;
D7_93(i,3) = temp_dress7_93;

DB8_93(i,1) = db8_93_sum(i);
DB8_93(i,2) = dressbal_br8_93;
DB8_93(i,3) = temp_db8_93;

Test9_93(i,1) = test9_93_sum(i);
Test9_93(i,2) = test_br9_93;
Test9_93(i,3) = temp_test9_93;

QA10_93(i,1) = QA_cyc10_93(i);

SHI11_93(i,1) = Shi_cyc11_93(i);

if i > 1

    QA2_93(i,2) = QA2_93_wait_time;
    CNC3_93(i,4) = cnc3_93_wait_time;
    CNC4_93(i,4) = cnc4_93_wait_time;
    MM5_93(i,4) = mm5_93_wait_time;
    MK6_93(i,4) = mk6_93_wait_time;
    D7_93(i,4) = dress7_93_wait_time;
    DB8_93(i,4) =  db8_93_wait_time;
    Test9_93(i,4) = test9_93_wait_time;
    QA10_93(i,2) = QA10_93_wait_time;
    SHI11_93(i,2) = Shi11_93_wait_time;

end

t_93(i,1) = REC_cyc1_93(i) + QA_cyc2_93(i) + cnc3_93_sum(i) + cnc4_93_sum(i) + mm5_93_sum(i) + ...
    mk6_93_sum(i) + dress7_93_sum(i) + db8_93_sum(i) + test9_93_sum(i) + QA_cyc10_93(i) + ...
    Shi_cyc11_93(i);

end

Cycle_Time_93 = cat(2,REC1_93(:,1), QA2_93(:,1), CNC3_93(:,1), CNC4_93(:,1), MM5_93(:,1), ...
    MK6_93(:,1), D7_93(:,1), DB8_93(:,1), Test9_93(:,1), QA10_93(:,1), SHI11_93(:,1));

Wait_Time_93 = cat(2, QA2_93(:,2), CNC3_93(:,4), CNC4_93(:,4), MM5_93(:,4), ...
    MK6_93(:,4), D7_93(:,4), DB8_93(:,4), Test9_93(:,4), QA10_93(:,2), SHI11_93(:,2));

Cycle_Time_93_Avg = mean(Cycle_Time_93);


[max_CT_93, process_93] = max(Cycle_Time_93,[],2);

Prod_3_br = cat(2, CNC3_93(:,2), CNC4_93(:,2), MM5_93(:,2), MK6_93(:,2),...
    D7_93(:,2), DB8_93(:,2), Test9_93(:,2));

%CNC3_93
[Time_CNC3_93,ia_93_CNC3,~] = unique(Prod_3_br(:,1));
ia_93_CNC3 = sort(ia_93_CNC3,'ascend');
CNC3_93_fail = numel(ia_93_CNC3);

%CNC4_93
[Time_CNC4_93,ia_93_CNC4,~] = unique(Prod_3_br(:,2));
ia_93_CNC4 = sort(ia_93_CNC4,'ascend');
CNC4_93_fail = numel(ia_93_CNC4);

%MM5_93
[Time_MM5_93,ia_93_MM5,~] = unique(Prod_3_br(:,3));
ia_93_MM5 = sort(ia_93_MM5,'ascend');
MM5_93_fail = numel(ia_93_MM5);

%MK6_93
[Time_MK6_93,ia_93_MK6,~] = unique(Prod_3_br(:,4));
ia_93_MK6 = sort(ia_93_MK6,'ascend');
MK6_93_fail = numel(ia_93_MK6);

%D7_93
[Time_D7_93,ia_93_D7,~] = unique(Prod_3_br(:,5));
ia_93_D7 = sort(ia_93_D7,'ascend');
D7_93_fail = numel(ia_93_D7);

%DB8_93
[Time_DB8_93,ia_93_DB8,~] = unique(Prod_3_br(:,6));
ia_93_DB8 = sort(ia_93_DB8,'ascend');
DB8_93_fail = numel(ia_93_DB8);

%Test9_93
[Time_Test9_93,ia_93_Test9,~] = unique(Prod_3_br(:,7));
ia_93_Test9 = sort(ia_93_Test9,'ascend');
Test9_93_fail = numel(ia_93_Test9);


%%
% Product 4 - 121757

Part4_cyc_std = [Part4.Avg_Hours Part4.Std_Dev_];

[cnc_br3_57,~,cnc_stup3_57] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[cnc_br4_57,~,cnc_stup4_57] = Cnc_horiz(CNC_br_mean,CNC_br_std,0,0,CNC_stup);

[mm_br5_57,~,mm_stup5_57] = Man_Mill(MM_br_mean, MM_br_std,0,0,MM_stup);

[mk_br6_57,~,mk_stup6_57] = Man_Key(MK_br_mean,MK_br_std,0,0,MK_stup);

[dress_br7_57,~,dress_stup7_57] = Dress(Dress_br_mean, Dress_br_std,0,0,Dress_stup);

[dressbal_br8_57,~,dressbal_stup8_57] = Dress_Bal(DB_br_mean, DB_br_std,0,0,DB_stup);

[test_br9_57,~,test_stup9_57] = Testing(Test_br_mean, Test_br_std,0,0,Test_stup);

[temp_cnc3_57, temp_cnc4_57, temp_mm5_57, temp_mk6_57, temp_dress7_57,...
    temp_db8_57, temp_test9_57] = deal(0);


for i = 1:cycles


    rec_cyc1_57(i) = abs(normrnd(3.96,1));  %REC 1

    QA_cyc2_57(i) = abs(normrnd(6.34,1.5)); %QA 2

    if i > 1

        if QA_cyc2_57(i) > rec_cyc1_57(i-1)

            QA2_57_wait_time = QA_cyc2_57(i) - rec_cyc1_57(i-1);

            QA_cyc2_57(i) = QA2_57_wait_time + QA_cyc2_57(i);

        else

            QA2_57_wait_time = 0;

            QA_cyc2_57(i) = QA2_57_wait_time + QA_cyc2_57(i);

        end

    end

    if temp_cnc3_57 >= cnc_br3_57  %CNC 3

        [cnc_br3_57,cnc_cyc3_57,~] = Cnc_horiz(CNC_br_mean,CNC_br_std, ...
            Part4_cyc_std(3,1),Part4_cyc_std(3,2),0);

        temp_cnc3_57 = 0;

        cnc3_57_sum(i) = cnc_cyc3_57 + abs(normrnd(6,0.5));

        temp_cnc3_57 = temp_cnc3_57 + cnc3_57_sum(i);

        if i > 1

            if cnc3_57_sum(i) > QA_cyc2_57(i-1)
                
                cnc3_57_wait_time = cnc3_57_sum(i) - QA_cyc2_57(i-1);

                cnc3_57_sum(i) = cnc3_57_wait_time + cnc_cyc3_57;

            else

                cnc3_57_wait_time = 0;

                cnc3_57_sum(i) = cnc3_57_wait_time + cnc_cyc3_57;

            end

        end

    else

         [~,cnc_cyc3_57,~] = Cnc_horiz(0,0,Part4_cyc_std(3,1),Part4_cyc_std(3,2),0);

         cnc3_57_sum(i) = cnc_cyc3_57;

         temp_cnc3_57 = temp_cnc3_57 + cnc3_57_sum(i);

         if i > 1

            if cnc3_57_sum(i) > QA_cyc2_57(i-1)
                
                cnc3_57_wait_time = cnc3_57_sum(i) - QA_cyc2_57(i-1);

                cnc3_57_sum(i) = cnc3_57_wait_time + cnc_cyc3_57;

            else

                cnc3_57_wait_time = 0;

                cnc3_57_sum(i) = cnc3_57_wait_time + cnc_cyc3_57;

            end

         end       
    
    end

    if temp_cnc4_57 >= cnc_br4_57  %CNC 4 


        [cnc_br4_57,cnc_cyc4_57,~] = Cnc_horiz(CNC_br_mean,CNC_br_std, ...
            Part4_cyc_std(4,1),Part4_cyc_std(4,2),0);
        
        temp_cnc4_57 = 0;
        
        cnc4_57_sum(i) = cnc_cyc4_57 + abs(normrnd(6,0.5));
        
        temp_cnc4_57 = temp_cnc4_57 + cnc4_57_sum(i);

        if i > 1

            if cnc4_57_sum(i) > cnc3_57_sum(i-1)

                cnc4_57_wait_time = cnc4_57_sum(i) - cnc3_57_sum(i-1);

                cnc4_57_sum(i) = cnc4_57_wait_time + cnc_cyc4_57;

            else

                cnc4_57_wait_time = 0;

                cnc4_57_sum(i) = cnc4_57_wait_time + cnc_cyc4_57;

            end

        end

    else

        [~,cnc_cyc4_57,~] = Cnc_horiz(0,0,Part4_cyc_std(4,1),Part4_cyc_std(4,2),0);

        cnc4_57_sum(i) = cnc_cyc4_57;
        
        temp_cnc4_57 = temp_cnc4_57 + cnc4_57_sum(i);

        if i > 1

            if cnc4_57_sum(i) > cnc3_57_sum(i-1)

                cnc4_57_wait_time = cnc4_57_sum(i) - cnc3_57_sum(i-1);

                cnc4_57_sum(i) = cnc4_57_wait_time + cnc_cyc4_57;

            else

                cnc4_57_wait_time = 0;

                cnc4_57_sum(i) = cnc4_57_wait_time + cnc_cyc4_57;

            end

        end

    end

    if temp_mm5_57 >= mm_br5_57  %MM 5

        [mm_br5_57,mm_cyc5_57,~] = Man_Mill(MM_br_mean, MM_br_std,...
            Part4_cyc_std(5,1),Part4_cyc_std(5,2),0);

        temp_mm5_57 = 0;

        mm5_57_sum(i) = mm_cyc5_57 + abs(normrnd(6,0.5));

        temp_mm5_57 = temp_mm5_57 + mm5_57_sum(i);

        if i > 1

            if mm5_57_sum(i) > cnc4_57_sum(i-1)

                mm5_57_wait_time = mm5_57_sum(i) - cnc4_57_sum(i-1);

                mm5_57_sum(i) = mm5_57_wait_time + mm_cyc5_57;

            else

                mm5_57_wait_time = 0;

                mm5_57_sum(i) = mm5_57_wait_time + mm_cyc5_57;
           
            end

        end

    else

        [~,mm_cyc5_57,~] = Man_Mill(0, 0, Part4_cyc_std(5,1),Part4_cyc_std(5,2),0);

         mm5_57_sum(i) = mm_cyc5_57;

        temp_mm5_57 = temp_mm5_57 + mm5_57_sum(i);

        if i > 1

            if mm5_57_sum(i) > cnc4_57_sum(i-1)

                mm5_57_wait_time = mm5_57_sum(i) - cnc4_57_sum(i-1);

                mm5_57_sum(i) = mm5_57_wait_time + mm_cyc5_57;

            else

                mm5_57_wait_time = 0;

                mm5_57_sum(i) = mm5_57_wait_time + mm_cyc5_57;
           
            end

        end       

    end

    if temp_mk6_57 >= mk_br6_57 % MK 6

        [mk_br6_57,mk_cyc6_57,~] = Man_Key(MK_br_mean, MK_br_std, Part4_cyc_std(6,1), ...
            Part4_cyc_std(6,2),0);

        temp_mk6_57 = 0;

        mk6_57_sum(i) = mk_cyc6_57 + abs(normrnd(6,0.5));

        temp_mk6_57 = temp_mk6_57 + mk6_57_sum(i);

        if i > 1

            if mk6_57_sum(i) > mm5_57_sum(i-1)

                mk6_57_wait_time = mk6_57_sum(i) - mm5_57_sum(i-1);

                mk6_57_sum(i) = mk6_57_wait_time + mk_cyc6_57;

            else

                mk6_57_wait_time = 0;

                mk6_57_sum(i) = mk6_57_wait_time + mk_cyc6_57;

            end

        end
                
    else

        [~,mk_cyc6_57,~] = Man_Key(0, 0, Part4_cyc_std(6,1),Part4_cyc_std(6,2),0);

        mk6_57_sum(i) = mk_cyc6_57;

        temp_mk6_57 = temp_mk6_57 + mk6_57_sum(i);

        if i > 1

            if mk6_57_sum(i) > mm5_57_sum(i-1)

                mk6_57_wait_time = mk6_57_sum(i) - mm5_57_sum(i-1);

                mk6_57_sum(i) = mk6_57_wait_time + mk_cyc6_57;

            else

                mk6_57_wait_time = 0;

                mk6_57_sum(i) = mk6_57_wait_time + mk_cyc6_57;

            end

        end

    end

    if temp_dress7_57 >= dress_br7_57 % D7

        [dress_br7_57,dress_cyc7_57,~] = Dress(Dress_br_mean, Dress_br_std, ...
            Part4_cyc_std(7,1),Part4_cyc_std(7,2),0);

        temp_dress7_57 = 0;

        dress7_57_sum(i) = dress_cyc7_57 + abs(normrnd(6,0.5));

        temp_dress7_57 = temp_dress7_57 + dress7_57_sum(i);

        if i > 1

            if dress7_57_sum(i) > mk6_57_sum(i-1)

                dress7_57_wait_time = dress7_57_sum(i) - mk6_57_sum(i-1);

                dress7_57_sum(i) = dress7_57_wait_time + dress_cyc7_57;

            else

                dress7_57_wait_time = 0;

                dress7_57_sum(i) = dress7_57_wait_time + dress_cyc7_57;

            end

        end
    
    else

        [~,dress_cyc7_57,~] = Dress(0, 0,Part4_cyc_std(7,1),Part4_cyc_std(7,2),0);

        dress7_57_sum(i) = dress_cyc7_57;

        temp_dress7_57 = temp_dress7_57 + dress7_57_sum(i);

        if i > 1

            if dress7_57_sum(i) > mk6_57_sum(i-1)

                dress7_57_wait_time = dress7_57_sum(i) - mk6_57_sum(i-1);

                dress7_57_sum(i) = dress7_57_wait_time + dress_cyc7_57;

            else

                dress7_57_wait_time = 0;

                dress7_57_sum(i) = dress7_57_wait_time + dress_cyc7_57;

            end

        end

    end

    if temp_db8_57 >= dressbal_br8_57 % DB 8

        [dressbal_br8_57,dressbal_cyc8_57,~] = Dress_Bal(DB_br_mean, DB_br_std, ...
            Part4_cyc_std(8,1),Part4_cyc_std(8,2),0);

        temp_db8_57 = 0;

        db8_57_sum(i) = dressbal_cyc8_57 + abs(normrnd(6,0.5));

        temp_db8_57 = temp_db8_57 + db8_57_sum(i);

        if i > 1

            if db8_57_sum(i) > dress7_57_sum(i-1)

                db8_57_wait_time = db8_57_sum(i) - dress7_57_sum(i-1);

                db8_57_sum(i) = db8_57_wait_time + dressbal_cyc8_57;

            else

                db8_57_wait_time = 0;

                db8_57_sum(i) = db8_57_wait_time + dressbal_cyc8_57;

            end

        end

    else

        [~,dressbal_cyc8_57,~] = Dress_Bal(0, 0, Part4_cyc_std(8,1),Part4_cyc_std(8,2),0);

        db8_57_sum(i) = dressbal_cyc8_57;

        temp_db8_57 = temp_db8_57 + db8_57_sum(i);

        if i > 1

            if db8_57_sum(i) > dress7_57_sum(i-1)

                db8_57_wait_time = db8_57_sum(i) - dress7_57_sum(i-1);

                db8_57_sum(i) = db8_57_wait_time + dressbal_cyc8_57;

            else

                db8_57_wait_time = 0;

                db8_57_sum(i) = db8_57_wait_time + dressbal_cyc8_57;

            end

        end

    end

    if temp_test9_57 >= test_br9_57 % T9

        [test_br9_57,test_cyc9_57,~] = Testing(Test_br_mean, Test_br_mean, ...
            Part4_cyc_std(9,1),Part4_cyc_std(9,2),0);

        temp_test9_57 = 0;

        test9_57_sum(i) = test_cyc9_57 + abs(normrnd(6,0.5));

        temp_test9_57 = temp_test9_57 + test9_57_sum(i);

        if i > 1

            if test9_57_sum(i) > db8_57_sum(i-1)

                test9_57_wait_time = test9_57_sum(i) - db8_57_sum(i-1);

                test9_57_sum(i) = test9_57_wait_time + test_cyc9_57;

            else

                test9_57_wait_time = 0;

                test9_57_sum(i) = test9_57_wait_time + test_cyc9_57;

            end

        end

    else

        [~,test_cyc9_57,~] = Testing(0, 0,Part4_cyc_std(9,1),Part4_cyc_std(9,2),0);

        test9_57_sum(i) = test_cyc9_57;

        temp_test9_57 = temp_test9_57 + test9_57_sum(i);

        if i > 1

            if test9_57_sum(i) > db8_57_sum(i-1)

                test9_57_wait_time = test9_57_sum(i) - db8_57_sum(i-1);

                test9_57_sum(i) = test9_57_wait_time + test_cyc9_57;

            else

                test9_57_wait_time = 0;

                test9_57_sum(i) = test9_57_wait_time + test_cyc9_57;

            end

        end

    end

    QA_cyc10_57(i) = abs(normrnd(4.44,1.5)); % QA 10

    if i > 1

        if QA_cyc10_57(i) > test9_57_sum(i-1)

            QA10_57_wait_time = QA_cyc10_57(i) - test9_57_sum(i-1);

            QA_cyc10_57(i) = QA10_57_wait_time + abs(normrnd(4.44,1.5));

        else

            QA10_57_wait_time = 0;

            QA_cyc10_57(i) = QA10_57_wait_time + abs(normrnd(4.44,1.5));

        end

    end

    Shi_cyc11_57(i) = abs(normrnd(1.79,0.75)); % SHI 11

    if i > 1

        if Shi_cyc11_57(i) > QA_cyc10_57(i-1)

            Shi11_57_wait_time = Shi_cyc11_57(i) - QA_cyc10_57(i-1);

            Shi_cyc11_57(i) = Shi11_57_wait_time + abs(normrnd(1.79,0.75));

        else

            Shi11_57_wait_time = 0;

            Shi_cyc11_57(i) = Shi11_57_wait_time + abs(normrnd(1.79,0.75));

        end

    end    
    
    REC1_57(i,1) = rec_cyc1_57(i);

    QA2_57(i,1) = QA_cyc2_57(i);

    CNC3_57(i,1) = cnc3_57_sum(i);
    CNC3_57(i,2) = cnc_br3_57;
    CNC3_57(i,3) = temp_cnc3_57;

    CNC4_57(i,1) = cnc4_57_sum(i);
    CNC4_57(i,2) = cnc_br4_57;
    CNC4_57(i,3) = temp_cnc4_57;

    MM5_57(i,1) = mm5_57_sum(i);
    MM5_57(i,2) = mm_br5_57;
    MM5_57(i,3) = temp_mm5_57;

    MK6_57(i,1) = mk6_57_sum(i);
    MK6_57(i,2) = mk_br6_57;
    MK6_57(i,3) = temp_mk6_57;

    D7_57(i,1) = dress7_57_sum(i);
    D7_57(i,2) = dress_br7_57;
    D7_57(i,3) = temp_dress7_57;

    DB8_57(i,1) = db8_57_sum(i);
    DB8_57(i,2) = dressbal_br8_57;
    DB8_57(i,3) = temp_db8_57;

    Test9_57(i,1) = test9_57_sum(i);
    Test9_57(i,2) = test_br9_57;
    Test9_57(i,3) = temp_test9_57;

    QA10_57(i,1) = QA_cyc10_57(i);

    SHI11_57(i,1) = Shi_cyc11_57(i);

    if i > 1

        QA2_57(i,2) = QA2_57_wait_time;
        CNC3_57(i,4) = cnc3_57_wait_time;
        CNC4_57(i,4) = cnc4_57_wait_time;
        MM5_57(i,4) = mm5_57_wait_time;
        MK6_57(i,4) = mk6_57_wait_time;
        D7_57(i,4) = dress7_57_wait_time;
        DB8_57(i,4) = db8_57_wait_time;
        Test9_57(i,4) = test9_57_wait_time;
        QA10_57(i,2) = QA10_57_wait_time;
        SHI11_57(i,2) = Shi11_57_wait_time;

    end


    t_57(i) = rec_cyc1_57(i) + QA_cyc2_57(i) + cnc3_57_sum(i) + cnc4_57_sum(i) +...
        mm5_57_sum(i) + mk6_57_sum(i) + dress7_57_sum(i) + db8_57_sum(i) + ...
        test9_57_sum(i) + QA_cyc10_57(i) + Shi_cyc11_57(i);

end


Cycle_Time_57 = cat(2,REC1_57(:,1), QA2_57(:,1), CNC3_57(:,1), CNC4_57(:,1), MM5_57(:,1), ...
    MK6_57(:,1), D7_57(:,1), DB8_57(:,1), Test9_57(:,1), QA10_57(:,1), SHI11_57(:,1));

Wait_Time_57 = cat(2, QA2_57(:,2), CNC3_57(:,4), CNC4_57(:,4), MM5_57(:,4), ...
    MK6_57(:,4), D7_57(:,4), DB8_57(:,4), Test9_57(:,4), QA10_57(:,2), SHI11_57(:,2));

Cycle_Time_57_Avg = mean(Cycle_Time_57);


[max_CT_57, process_57] = max(Cycle_Time_57,[],2);

Prod_4_br = cat(2, CNC3_57(:,2), CNC4_57(:,2), MM5_57(:,2), MK6_57(:,2),...
    D7_57(:,2), DB8_57(:,2), Test9_57(:,2));

%CNC3_57
[Time_CNC3_57,ia_57_CNC3,~] = unique(Prod_4_br(:,1));
ia_57_CNC3 = sort(ia_57_CNC3,'ascend');
CNC3_57_fail = numel(ia_57_CNC3);

%CNC4_57
[Time_CNC4_57,ia_57_CNC4,~] = unique(Prod_4_br(:,2));
ia_57_CNC4 = sort(ia_57_CNC4,'ascend');
CNC4_57_fail = numel(ia_57_CNC4);

%MM5_57
[Time_MM5_57,ia_57_MM5,~] = unique(Prod_4_br(:,3));
ia_57_MM5 = sort(ia_57_MM5,'ascend');
MM5_57_fail = numel(ia_57_MM5);

%MK6_57
[Time_MK6_57,ia_57_MK6,~] = unique(Prod_4_br(:,4));
ia_57_MK6 = sort(ia_57_MK6,'ascend');
MK6_57_fail = numel(ia_57_MK6);

%D7_57
[Time_D7_57,ia_57_D7,~] = unique(Prod_4_br(:,5));
ia_57_D7 = sort(ia_57_D7,'ascend');
D7_57_fail = numel(ia_57_D7);

%DB8_57
[Time_DB8_57,ia_57_DB8,~] = unique(Prod_4_br(:,6));
ia_57_DB8 = sort(ia_57_DB8,'ascend');
DB8_57_fail = numel(ia_57_DB8);

%Test9_57
[Time_Test9_57,ia_57_Test9,~] = unique(Prod_4_br(:,7));
ia_57_Test9 = sort(ia_57_Test9,'ascend');
Test9_57_fail = numel(ia_57_Test9);





%%
% 
% for i = 1:60
% 
%     hold on;
% 
%     bar(Cycle_Time(1,:))
% 
%     hold off;
% 
% end

figure();

t_bar_names = categorical({'P 72','P 54','P 57','P 93'});
t_bar_names = reordercats(t_bar_names, {'P 72','P 54','P 57','P 93'});

t_bar = bar(t_bar_names,[mean(t),mean(t_54),mean(t_57),mean(t_93)]);

text(t_bar.XEndPoints,t_bar.YEndPoints,string(round(t_bar.YData,2)),...
    'HorizontalAlignment','center','VerticalAlignment','bottom')

title("Average cycle time for each product line")
ylabel('Time in hrs')




%%


Avg_cyc1 = mean(Cycle_Time);
Avg_cyc2 = mean(Cycle_Time_54);
Avg_cyc3 = mean(Cycle_Time_93);
Avg_cyc4 = mean(Cycle_Time_57);

x = zeros(4,19);
x(1,:) = Avg_cyc1;
x(2,1:16) = Avg_cyc2;
x(3,1:11) = Avg_cyc3;
x(4,1:11) = Avg_cyc4;


%%

%figure()

%tiledlayout(2,2);

%nexttile

%%
% Product 1

figure();

x_bar_72 = categorical({'CNC3','CNC4','CNC5','Man6','CNC7','CNC8','CNC9',...
    'MM10','MK11','D13','DB16','DB17'});
x_bar_72 = reordercats(x_bar_72, {'CNC3','CNC4','CNC5','Man6','CNC7','CNC8','CNC9',...
    'MM10','MK11','D13','DB16','DB17'});

heading_72 = categorical({'REC1', 'QA2', 'CNC3', 'CNC4', 'CNC5', 'Man6', 'CNC7', 'CNC8',...
    'CNC9', 'MM10', 'MK11', 'QA12', 'D13','QA14', 'AS15', 'DB16', 'DB17',...
    'QA18', 'SHI19'});

heading_72 = reordercats(heading_72, {'REC1', 'QA2', 'CNC3', 'CNC4', 'CNC5', 'Man6', 'CNC7', 'CNC8',...
    'CNC9', 'MM10', 'MK11', 'QA12', 'D13','QA14', 'AS15', 'DB16', 'DB17',...
    'QA18', 'SHI19'});

%Avg Cycle Time

Avg_72 = bar(heading_72,Cycle_Time_Avg,'FaceColor','flat');

ylabel("Average Time in hours");
title(["Average Time taken by each process for Part 124672 for", num2str(cycles), " cycles"]);

xtips_72_avg = Avg_72.XEndPoints;
ytips_72_avg = Avg_72.YEndPoints;
labels_72_avg = string(round(Avg_72.YData,1));

text(xtips_72_avg,ytips_72_avg,labels_72_avg,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

[~,a] = max(Cycle_Time_Avg);
CT_temp = Cycle_Time_Avg;

Avg_72.CData(a,:) = [1 0 0];

CT_temp(a) = NaN;
[~,a] = max(CT_temp);

Avg_72.CData(a,:) = Crim;


% Number of Failures

figure();

Fail_72 = [CNC3_fail,CNC4_fail,CNC5_fail,Man6_fail,CNC7_fail,CNC8_fail,CNC9_fail,...
    MM10_fail,MK11_fail,D13_fail,DB16_fail,DB17_fail];

Fail_bar_72 = bar(x_bar_72, round(Fail_72,1),'FaceColor','flat');


title(['Number of time each process fails for Part 124672 for ', num2str(cycles),' cycles'])

ylabel("Number of failures")

xtips_72 = Fail_bar_72.XEndPoints;
ytips_72 = Fail_bar_72.YEndPoints;
labels_72 = string(Fail_bar_72.YData);

text(xtips_72,ytips_72,labels_72,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

[~,b] = max(Fail_72);
F_temp = Fail_72;

Fail_bar_72.CData(b,:) = [1 0 0];

F_temp(b) = NaN;
[~,b] = max(F_temp);

Fail_bar_72.CData(b,:) = Crim;


% Reliability Product 1

figure();

Reli_72 = 1 - Fail_72 ./ cycles;

Reli_bar_72 = bar(x_bar_72, Reli_72, 'FaceColor','flat');

title(['Reliability of each process for Part 124672 for ',num2str(cycles), ' cycles'])
ylabel("Reliability")

xreli_72 = Reli_bar_72.XEndPoints;
yreli_72 = Reli_bar_72.YEndPoints;
labels_72_reli = string(round(Reli_bar_72.YData,2));


text(xreli_72,yreli_72,labels_72_reli,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')


[~,c] = min(Reli_72);
R_temp = Reli_72;

Reli_bar_72.CData(c,:) = [1 0 0];

R_temp(c) = NaN;
[~,c] = min(R_temp);

Reli_bar_72.CData(c,:) = Crim;

% Wait time 1

figure();

heading_72_wait = categorical({'QA2', 'CNC3', 'CNC4', 'CNC5', 'Man6', 'CNC7', 'CNC8',...
    'CNC9', 'MM10', 'MK11', 'QA12', 'D13','QA14', 'AS15', 'DB16', 'DB17',...
    'QA18', 'SHI19'});

heading_72_wait = reordercats(heading_72_wait, { 'QA2', 'CNC3', 'CNC4', 'CNC5', 'Man6', 'CNC7', 'CNC8',...
    'CNC9', 'MM10', 'MK11', 'QA12', 'D13','QA14', 'AS15', 'DB16', 'DB17',...
    'QA18', 'SHI19'});


Wait_Time_bar = bar(heading_72_wait, mean(Wait_Time),'FaceColor','flat');

title("Mean Wait Times for Part 124672")
ylabel('Time (in hrs)')

xwait_72 = Wait_Time_bar.XEndPoints;
ywait_72 = Wait_Time_bar.YEndPoints;
labels_72_wait = string(round(Wait_Time_bar.YData,1));


text(xwait_72,ywait_72,labels_72_wait,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')


[~,c] = max(mean(Wait_Time));
W_temp = mean(Wait_Time);

Wait_Time_bar.CData(c,:) = [1 0 0];

W_temp(c) = NaN;
[~,c] = max(W_temp);

Wait_Time_bar.CData(c,:) = Crim;


%%
%Product 2

%nexttile

figure();

x_bar_54 = categorical({'CNC3_54','CNC4_54','MAN5_54','CNC6_54','MM7_54',...
    'D10_54','CNC12_54','DB13_54',';CNC14_54'});

x_bar_54 = reordercats(x_bar_54, {'CNC3_54','CNC4_54','MAN5_54','CNC6_54','MM7_54',...
    'D10_54','CNC12_54','DB13_54',';CNC14_54'});

headings_54 = categorical({'REC1', 'QA2', 'CNC3', 'CNC4', 'MAN5',...
    'CNC6', 'MM7', 'OSP8', 'QA9', 'D10', 'QA11',...
    'CNC12', 'DB13_54', 'CNC14', 'QA15', 'SHI16'});

headings_54 = reordercats(headings_54,{'REC1', 'QA2', 'CNC3', 'CNC4', 'MAN5',...
    'CNC6', 'MM7', 'OSP8', 'QA9', 'D10', 'QA11',...
    'CNC12', 'DB13_54', 'CNC14', 'QA15', 'SHI16'});

% Avg Time

Avg_54 = bar(headings_54,Cycle_Time_54_Avg,'FaceColor','flat');

title(['Average time taken by each process for Part 126054 for ',num2str(cycles), ' cycles'])
ylabel("Average Time in hours")

xtips_54_avg = Avg_54.XEndPoints;
ytips_54_avg = Avg_54.YEndPoints;
labels_54_avg = string(round(Avg_54.YData,2));

text(xtips_54_avg,ytips_54_avg,labels_54_avg,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')


[~,a] = max(Cycle_Time_54_Avg);
CT_temp = Cycle_Time_54_Avg;

Avg_54.CData(a,:) = [1 0 0];

CT_temp(a) = NaN;
[~,a] = max(CT_temp);

Avg_54.CData(a,:) = Crim;


% Number of Failures
figure();

Fail_54 = [CNC3_54_fail,CNC4_54_fail,MAN5_54_fail,CNC6_54_fail,...
    MM7_54_fail,D10_54_fail,CNC12_54_fail,DB13_54_fail,CNC14_54_fail];

Fail_bar_54 = bar(x_bar_54,Fail_54,'FaceColor','flat');

title(['Number of time each process fails for Part 126054 for ',num2str(cycles),' cycles'])
ylabel("Number of failures")

xtips_54 = Fail_bar_54.XEndPoints;
ytips_54 = Fail_bar_54.YEndPoints;
labels_54 = string(Fail_bar_54.YData);

text(xtips_54,ytips_54,labels_54,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

[~,b] = max(Fail_54);
F_temp = Fail_54;

Fail_bar_54.CData(b,:) = [1 0 0];

F_temp(b) = NaN;
[~,b] = max(F_temp);

Fail_bar_54.CData(b,:) = Crim;


%Reliability

figure();

Reli_54 = 1 - Fail_54 ./ cycles;
Reli_54_bar = bar(x_bar_54,Reli_54,'FaceColor','flat');


title(['Reliability of each process for Part 126054 for ',num2str(cycles),' cycles'])
ylabel("Reliability")

xreli_54 = Reli_54_bar.XEndPoints;
yreli_54 = Reli_54_bar.YEndPoints;
labels_54_reli = string(round(Reli_54_bar.YData,3));

text(xreli_54,yreli_54,labels_54_reli,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

[~,c] = min(Reli_54);
R_temp = Reli_54;

Reli_54_bar.CData(c,:) = [1 0 0];

R_temp(c) = NaN;
[~,c] = min(R_temp);

Reli_54_bar.CData(c,:) = Crim;

%Wait_Time

figure();

headings_54_wait = categorical({'QA2', 'CNC3', 'CNC4', 'MAN5',...
    'CNC6', 'MM7', 'OSP8', 'QA9', 'D10', 'QA11',...
    'CNC12', 'DB13_54', 'CNC14', 'QA15', 'SHI16'});

headings_54_wait = reordercats(headings_54_wait,{'QA2', 'CNC3', 'CNC4', 'MAN5',...
    'CNC6', 'MM7', 'OSP8', 'QA9', 'D10', 'QA11',...
    'CNC12', 'DB13_54', 'CNC14', 'QA15', 'SHI16'});

Wait_Time_bar_54 = bar(headings_54_wait, mean(Wait_Time_54),'FaceColor','flat');

title("Mean Wait Times for Part 126254")
ylabel('Time (in hrs)')

xwait_54 = Wait_Time_bar_54.XEndPoints;
ywait_54 = Wait_Time_bar_54.YEndPoints;
labels_54_wait = string(round(Wait_Time_bar_54.YData,1));


text(xwait_54,ywait_54,labels_54_wait,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')


[~,c] = max(mean(Wait_Time_54));
W_temp = mean(Wait_Time_54);

Wait_Time_bar_54.CData(c,:) = [1 0 0];

W_temp(c) = NaN;
[~,c] = max(W_temp);

Wait_Time_bar_54.CData(c,:) = Crim;


%%

%Product3

%nexttile

figure()

x_bar_93 = categorical({'CNC3_93','CNC4_93','MM5_93','MK6_93',...
    'D7_93','DB8_93','Test9_93'});

x_bar_93 = reordercats(x_bar_93,{'CNC3_93','CNC4_93','MM5_93','MK6_93',...
    'D7_93','DB8_93','Test9_93'});

headings_93 = categorical({'REC1', 'QA2', 'CNC3', 'CNC4', 'MM5', ...
    'MK6', 'D7', 'DB8', 'Test9', 'QA10', 'SHI11'});

headings_93 = reordercats(headings_93, {'REC1', 'QA2', 'CNC3', 'CNC4', 'MM5', ...
    'MK6', 'D7', 'DB8', 'Test9', 'QA10', 'SHI11'});

% Avg Time

Avg_93 = bar(headings_93,Cycle_Time_93_Avg, 'FaceColor', 'flat');

title(['Average time taken for each process for Part 126293 for ',num2str(cycles),' cycles'])
ylabel("Average Time in hours")

xtips_93_avg = Avg_93.XEndPoints;
ytips_93_avg = Avg_93.YEndPoints;
labels_93_avg = string(round(Avg_93.YData,2));

text(xtips_93_avg,ytips_93_avg,labels_93_avg,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');

[~,a] = max(Cycle_Time_93_Avg);
CT_temp = Cycle_Time_93_Avg;

Avg_93.CData(a,:) = [1 0 0];

CT_temp(a) = NaN;
[~,a] = max(CT_temp);

Avg_93.CData(a,:) = Crim;


% Number of Failures

figure();

Fail_93 = [CNC3_93_fail,CNC4_93_fail,MM5_93_fail,MK6_93_fail,...
    D7_93_fail,DB8_93_fail,Test9_93_fail];


Fail_bar_93 = bar(x_bar_93,Fail_93,'FaceColor', 'flat');

title(['Number of time each process fails for Part 126293 for ',num2str(cycles),' cycles'])
ylabel("Number of failures")

xtips_93 = Fail_bar_93.XEndPoints;
ytips_93 = Fail_bar_93.YEndPoints;
labels_93 = string(Fail_bar_93.YData);

text(xtips_93,ytips_93,labels_93,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

[~,b] = max(Fail_93);
F_temp = Fail_93;

Fail_bar_93.CData(b,:) = [1 0 0];

F_temp(b) = NaN;
[~,b] = max(F_temp);

Fail_bar_93.CData(b,:) = Crim;

%Reliability

figure();

Reli_93 = 1 - Fail_93 ./ cycles;

Reli_bar_93 = bar(x_bar_93, Reli_93,'FaceColor', 'flat');

title(['Reliability of each process for Part 126293 for ',num2str(cycles),' cycles'])
ylabel("Reliability")

xreli_93 = Reli_bar_93.XEndPoints;
yreli_93 = Reli_bar_93.YEndPoints;
labels_93_reli = string(round(Reli_bar_93.YData,3));

text(xreli_93,yreli_93,labels_93_reli,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

[~,c] = min(Reli_93);
R_temp = Reli_93;

Reli_bar_93.CData(c,:) = [1 0 0];

R_temp(c) = NaN;
[~,c] = min(R_temp);

Reli_bar_93.CData(c,:) = Crim;

%Wait Times

figure();

headings_93_wait = categorical({'QA2', 'CNC3', 'CNC4', 'MM5', ...
    'MK6', 'D7', 'DB8', 'Test9', 'QA10', 'SHI11'});

headings_93_wait = reordercats(headings_93_wait, {'QA2', 'CNC3', 'CNC4', 'MM5', ...
    'MK6', 'D7', 'DB8', 'Test9', 'QA10', 'SHI11'});

Wait_Time_bar_93 = bar(headings_93_wait, mean(Wait_Time_93),'FaceColor','flat');

title("Mean Wait Times for Part 126293")
ylabel('Time (in hrs)')

xwait_93 = Wait_Time_bar_93.XEndPoints;
ywait_93 = Wait_Time_bar_93.YEndPoints;
labels_93_wait = string(round(Wait_Time_bar_93.YData,1));


text(xwait_93,ywait_93,labels_93_wait,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')


[~,c] = max(mean(Wait_Time_93));
W_temp = mean(Wait_Time_93);

Wait_Time_bar_93.CData(c,:) = [1 0 0];

W_temp(c) = NaN;
[~,c] = max(W_temp);

Wait_Time_bar_93.CData(c,:) = Crim;


%%

%Product4

%nexttile

figure();


x_bar_57 = categorical({'CNC3_57','CNC4_57','MM5_57','MK6_57','D7_57','DB8_57',...
    'Test9_57'});

x_bar_57 = reordercats(x_bar_57,{'CNC3_57','CNC4_57','MM5_57','MK6_57',...
    'D7_57','DB8_57','Test9_57'});

headings_57 = categorical({'REC1', 'QA2', 'CNC3', 'CNC4', 'MM5', ...
    'MK6', 'D7', 'DB8', 'Test9', 'QA10', 'SHI11'});

headings_57 = reordercats(headings_57,{'REC1', 'QA2', 'CNC3', 'CNC4', 'MM5', ...
    'MK6', 'D7', 'DB8', 'Test9', 'QA10', 'SHI11'});

%Avg Time

Avg_57 = bar(headings_57,Cycle_Time_57_Avg,'FaceColor','flat');

title(['Average time each process takes for Part 121757 for ',num2str(cycles),' cycles'])
ylabel("Average Time in hours")

xtips_57_avg = Avg_57.XEndPoints;
ytips_57_avg = Avg_57.YEndPoints;
labels_57_avg = string(round(Avg_57.YData,2));

text(xtips_57_avg,ytips_57_avg,labels_57_avg,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

[~,a] = max(Cycle_Time_57_Avg);
CT_temp = Cycle_Time_57_Avg;

Avg_57.CData(a,:) = [1 0 0];

CT_temp(a) = NaN;
[~,a] = max(CT_temp);

Avg_57.CData(a,:) = Crim;

% Number of Failures
figure();

Fail_57 = [CNC3_57_fail,CNC4_57_fail,MM5_57_fail,MK6_57_fail,...
    D7_57_fail,DB8_57_fail,Test9_57_fail];


Fail_bar_57 = bar(x_bar_57,Fail_57,'FaceColor','flat');

title(['Number of time each process fails for Part 121757 for ',num2str(cycles),' cycles'])
ylabel("Number of failures")

xtips_57 = Fail_bar_57.XEndPoints;
ytips_57 = Fail_bar_57.YEndPoints;
labels_57 = string(Fail_bar_57.YData);

text(xtips_57,ytips_57,labels_57,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

[~,b] = max(Fail_57);
F_temp = Fail_57;

Fail_bar_57.CData(b,:) = [1 0 0];

F_temp(b) = NaN;
[~,b] = max(F_temp);

Fail_bar_57.CData(b,:) = Crim;

%Reliability

figure();

Reli_57 = 1 - Fail_57 ./ cycles;
Reli_bar_57 = bar(x_bar_57,Reli_57,'FaceColor','flat');

title(['Reliability of each process for Part 121757 for ',num2str(cycles),' cycles'])
ylabel("Reliability")

xreli_57 = Reli_bar_57.XEndPoints;
yreli_57 = Reli_bar_57.YEndPoints;
labels_57_reli = string(round(Reli_bar_57.YData,3));

text(xreli_57,yreli_57,labels_57_reli,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

[~,c] = min(Reli_57);
R_temp = Reli_57;

Reli_bar_57.CData(c,:) = [1 0 0];

R_temp(c) = NaN;
[~,c] = min(R_temp);

Reli_bar_57.CData(c,:) = Crim;

% Wait Time

figure();

headings_57_wait = categorical({ 'QA2', 'CNC3', 'CNC4', 'MM5', ...
    'MK6', 'D7', 'DB8', 'Test9', 'QA10', 'SHI11'});

headings_57_wait = reordercats(headings_57_wait,{ 'QA2', 'CNC3', 'CNC4', 'MM5', ...
    'MK6', 'D7', 'DB8', 'Test9', 'QA10', 'SHI11'});

Wait_Time_bar_57 = bar(headings_57_wait, mean(Wait_Time_57),'FaceColor','flat');

title("Mean Wait Times for Part 121757")
ylabel('Time (in hrs)')

xwait_57 = Wait_Time_bar_57.XEndPoints;
ywait_57 = Wait_Time_bar_57.YEndPoints;
labels_57_wait = string(round(Wait_Time_bar_57.YData,1));


text(xwait_57,ywait_57,labels_57_wait,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')


[~,c] = max(mean(Wait_Time_57));
W_temp = mean(Wait_Time_57);

Wait_Time_bar_57.CData(c,:) = [1 0 0];

W_temp(c) = NaN;
[~,c] = max(W_temp);

Wait_Time_bar_57.CData(c,:) = Crim;


%%
%Total brakdowns in each line
figure()

title('Total Breakdowns in each part line')
Fail_total = [sum(Fail_72),sum(Fail_54),sum(Fail_93),sum(Fail_57)];

Fail_total_bar = bar(t_bar_names,Fail_total,'FaceColor','flat');

title(strcat("Total breakdowns for each product for ", string(cycles), ' cycles'))
ylabel("Number of failures")

xtips_fail = Fail_total_bar.XEndPoints;
ytips_fail = Fail_total_bar.YEndPoints;
labels_fail = string(Fail_total_bar.YData);

text(xtips_fail,ytips_fail,labels_fail,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')



%Reliability of each part production line assuming that its in series

Reli_Prodline = [prod(Reli_72),prod(Reli_54), prod(Reli_93), prod(Reli_57)];

figure();

Reli_Prodline_bar = bar(t_bar_names,Reli_Prodline);

title(["Reliability of each Product line in series for " num2str(cycles) "cycles"])
ylabel("Reliability")

xtips_reli = Reli_Prodline_bar.XEndPoints;
ytips_reli = Reli_Prodline_bar.YEndPoints;
labels_reli = string(round(Reli_Prodline_bar.YData,2));

text(xtips_reli,ytips_reli,labels_reli,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

%%
Cost_names = Master_tab.WorkCenterNo';

Cost_bar = bar(categorical(Cost_names), Master_tab.CostOfWC);

title('Cost Of Work Centers')
ylabel('Cost in dollars')

xtips_cost = Cost_bar.XEndPoints;
ytips_cost = Cost_bar.YEndPoints;
labels_cost = string(Cost_bar.YData ./ 10^4);

text(xtips_cost,ytips_cost,labels_cost,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');



%%
function [Brk_dwn, Cyc_Time, Set_Up] = Cnc_horiz(Mean_br, Std_br, Avg_Time, Std_dev, Set_Up)


   Brk_dwn = abs(normrnd(Mean_br,Std_br));
   
   Cyc_Time = abs(normrnd(Avg_Time,Std_dev));

end

function [Brk_dwn, Cyc_Time, Set_Up] = Man_Sftlth(Mean_br, Std_br, Avg_Time, Std_dev, Set_Up)

    Brk_dwn = abs(normrnd(Mean_br, Std_br));

    Cyc_Time = abs(normrnd(Avg_Time,Std_dev));

end


function [Brk_dwn, Cyc_Time, Set_Up] = Man_Mill(Mean_br, Std_br, Avg_Time, Std_dev, Set_Up)

    Brk_dwn = abs(normrnd(Mean_br,Std_br));

    Cyc_Time = abs(normrnd(Avg_Time,Std_dev));

end


function [Brk_dwn, Cyc_Time, Set_Up] = Man_Key(Mean_br, Std_br, Avg_Time, Std_dev, Set_Up)

    Brk_dwn = abs(normrnd(Mean_br,Std_br));

    Cyc_Time = abs(normrnd(Avg_Time,Std_dev));

end


function [Brk_dwn, Cyc_Time, Set_Up] = Dress(Mean_br, Std_br, Avg_Time, Std_dev, Set_Up)


    Brk_dwn = abs(normrnd(Mean_br,Std_br));

    Cyc_Time = abs(normrnd(Avg_Time,Std_dev));

end

function [Brk_dwn, Cyc_Time, Set_Up] = Dress_Bal(Mean_br, Std_br, Avg_Time, Std_dev, Set_Up)

    Brk_dwn = abs(normrnd(Mean_br,Std_br));
    
    Cyc_Time = abs(normrnd(Avg_Time,Std_dev));   

end

             
function [Brk_dwn, Cyc_Time, Set_Up] = Testing(Mean_br, Std_br, Avg_Time, Std_dev, Set_Up)

    Brk_dwn = abs(normrnd(Mean_br,Std_br));

    Cyc_Time = abs(normrnd(Avg_Time,Std_dev));

end
