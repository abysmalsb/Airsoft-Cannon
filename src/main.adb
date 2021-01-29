with MicroBit.IOs; use MicroBit.IOs;
with MicroBit.Servos; use MicroBit.Servos;
with MicroBit.Time; use MicroBit.Time;
with MicroBit.Display; use MicroBit.Display;
with MicroBit.Display.Cannon; use MicroBit.Display.Cannon;

procedure Main is
   ESC_Pin : constant := 0;
   Vertical_Servo_Pin : constant := 1;
   Horizontal_Servo_Pin : constant := 2;
   Solenoid_Pin : constant := 5;
   Vertical_Max_Angle : constant := 70;
   Vertical_Min_Angle : constant := 25;
   Update_Pin : constant := 11;
   Left_Pin : constant := 13;
   Up_Pin : constant := 14;
   Down_Pin : constant := 15;
   Right_Pin : constant := 16;

   Can_Be_Armed : Boolean := True;
   Armed : Boolean := False;

   Update_State : Boolean;
   Left_State : Boolean;
   Up_State : Boolean;
   Down_State : Boolean;
   Right_State : Boolean;
   X_Updated : Boolean;
   Y_Updated : Boolean;
   Firing : Boolean := False;
   Move_X : Integer := 0;
   Move_Y : Integer := 0;
   Vertical_Angle : Servo_Set_Point := 50;

begin
   -- Go (ESC_Pin, 50);
   -- Go (Vertical_Servo_Pin, Vertical_Angle);
   Delay_Ms(500);
   Stop (Vertical_Servo_Pin);
   MicroBit.IOs.Set (Solenoid_Pin, False);

   --  Loop forever
   loop
      Clear;

      Update_State := MicroBit.IOs.Set (Update_Pin);
      Left_State := MicroBit.IOs.Set (Left_Pin);
      Up_State := MicroBit.IOs.Set (Up_Pin);
      Down_State := MicroBit.IOs.Set (Down_Pin);
      Right_State := MicroBit.IOs.Set (Right_Pin);

      if not Armed then
         Not_Armed;
      end if;


      if Update_State then
         Firing := False;
         X_Updated := False;
         Y_Updated := False;
         Move_X := 0;
         Move_Y := 0;

         if (Left_State) then
            Move_X := -1;
            X_Updated := True;
         end if;
         if (Right_State) then
            Move_X := Move_X + 1;
         end if;
         if (Down_State) then
            Move_Y := -1;
            Y_Updated := True;
         end if;
         if (Up_State) then
            Move_Y := Move_Y + 1;
         end if;

         if (Move_X = 0 and then
             Move_Y = 0 and then
             X_Updated and then
             Y_Updated and then
             Can_Be_Armed) then

            Armed := not Armed;
            Can_Be_Armed := False;
         elsif (Move_X = 0 and then
                Move_Y = 0 and then
                X_Updated and then
                  not Y_Updated) then

            Firing := True;
         end if;

         if Armed then
            -- Update display and actuators
            -- Go (ESC_Pin, 130);

            if Move_X < 0 then
               Move_Left;
               Go (Horizontal_Servo_Pin, 90);
            elsif Move_X > 0 then
               Move_Right;
               Go (Horizontal_Servo_Pin, 86);
            else
               Stop (Horizontal_Servo_Pin);
            end if;

            if Move_Y < 0 then
               Move_Down;
               Vertical_Angle := Vertical_Angle - 1;
               if Vertical_Angle < Vertical_Min_Angle then
                  Vertical_Angle := Vertical_Min_Angle;
               end if;
               Go (Vertical_Servo_Pin, Vertical_Angle);
            elsif Move_Y > 0 then
               Move_Up;
               Vertical_Angle := Vertical_Angle + 1;
               if Vertical_Angle > Vertical_Max_Angle then
                  Vertical_Angle := Vertical_Max_Angle;
               end if;
               Go (Vertical_Servo_Pin, Vertical_Angle);
            else
               Stop (Vertical_Servo_Pin);
            end if;

            if Firing then
               Fire;
               MicroBit.IOs.Set (Solenoid_Pin, True);
               Delay_Ms(50);
               MicroBit.IOs.Set (Solenoid_Pin, False);
               Delay_Ms(50);
            end if;
         else
            -- Go (ESC_Pin, 50);
         end if;
      else
         Can_Be_Armed := True;
         Stop (Horizontal_Servo_Pin);
         Stop (Vertical_Servo_Pin);
      end if;

      Delay_Ms(25);
   end loop;
end Main;
