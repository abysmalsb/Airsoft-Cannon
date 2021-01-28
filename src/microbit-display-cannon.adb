with MicroBit.Display; use MicroBit.Display;
with MicroBit.Display.Symbols; use MicroBit.Display.Symbols;

package body MicroBit.Display.Cannon is

   ----------------
   -- Move_Left --
   ----------------

   procedure Move_Left is
   begin
      Set(0, 2);
      Set(1, 2);
      Set(2, 2);
   end Move_Left;

   ----------------
   -- Move_Right --
   ----------------

   procedure Move_Right is
   begin
      Set(2, 2);
      Set(3, 2);
      Set(4, 2);
   end Move_Right;

   -------------
   -- Move_Up --
   -------------

   procedure Move_Up is
   begin
      Set(2, 0);
      Set(2, 1);
      Set(2, 2);
   end Move_Up;

   ---------------
   -- Move_Down --
   ---------------

   procedure Move_Down is
   begin
      Set(2, 2);
      Set(2, 3);
      Set(2, 4);
   end Move_Down;

   ---------------
   -- Not_Armed --
   ---------------

   procedure Not_Armed is
   begin
      Heart;
   end Not_Armed;

   ----------
   -- Fire --
   ----------

   procedure Fire is
   begin
      Display ('+');
      Set(2, 0);
      Set(2, 4);
      Set(0, 2);
      Set(4, 2);
   end Fire;

end MicroBit.Display.Cannon;
