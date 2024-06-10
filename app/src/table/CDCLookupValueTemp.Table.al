table 6085607 "CDC Lookup Value Temp"
{
    Caption = 'Lookup Value';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; Value; Text[50])
        {
            Caption = 'Value';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}