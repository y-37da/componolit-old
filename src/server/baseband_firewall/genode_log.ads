package Genode_Log
with
    Abstract_State => State,
    Initializes    => State
is

    procedure Log (Msg : String)
    with
        Pre => Msg'Length < 1024,
        Global => (In_Out => State);

    procedure Warn (Msg : String)
    with
        Pre => Msg'Length < 1024,
        Global => (In_Out => State);

    procedure Error (Msg : String)
    with
        Pre => Msg'Length < 1024,
        Global => (In_Out => State);

    procedure Int (Num : Integer)
    with
        Global => (In_Out => State);

end Genode_Log;