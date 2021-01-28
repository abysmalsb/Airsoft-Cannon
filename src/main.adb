with MicroBit.IOs;
with MicroBit.Time; use MicroBit.Time;
with MicroBit.Display; use MicroBit.Display;
with MicroBit.Display.Cannon; use MicroBit.Display.Cannon;

procedure Main is

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

begin
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
         if Armed then
            -- Update actuators and display
            if Move_X < 0 then
               Move_Left;
            end if;
            if Move_Y > 0 then
               Move_Up;
            end if;
            if Move_Y < 0 then
               Move_Down;
            end if;
            if Move_X > 0 then
               Move_Right;
            end if;
            if Firing then
               Fire;
            end if;

         end if;

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
      else
         Can_Be_Armed := True;
      end if;

      Delay_Ms(5);
   end loop;

end Main;
