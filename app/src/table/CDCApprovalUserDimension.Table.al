table 6085748 "CDC Approval User Dimension"
{
    Caption = 'Approval User Dimension';

    fields
    {
        field(1; "Approval Group Code"; Code[10])
        {
            Caption = 'Approval Group Code';
        }
        field(2; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(4; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
        }
        field(5; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
        }
        field(6; "Approval Permission"; Boolean)
        {
            Caption = 'Approval Permission';
        }
        field(7; "Dimension Value Description"; Text[50])
        {
            Caption = 'Dimension Value Description';
        }
    }

    keys
    {
        key(Key1; "Approval Group Code", "User ID", "Entry No.", "Dimension Code", "Dimension Value Code")
        {
            Clustered = true;
        }
    }
    procedure OpenTableFilterList(AdvAppvlSetup: Record "CDC Approval User"; DimIndex: Integer)
    begin
    end;

    procedure SetRecord(TempAdvAppvlDimFilter: Record "CDC Approval User Dimension" temporary)
    begin
    end;
}