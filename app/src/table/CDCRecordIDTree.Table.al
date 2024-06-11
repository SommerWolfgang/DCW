table 6085763 "CDC Record ID Tree"
{
    Caption = 'Record ID Tree';

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
        }
        field(2; "Parent ID"; Integer)
        {
            Caption = 'Parent ID';
            TableRelation = "CDC Record ID Tree";
        }
        field(3; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(4; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(5; "Key Index"; Integer)
        {
            Caption = 'Key Index';
        }
        field(6; "Value (Text)"; Text[200])
        {
            Caption = 'Value (Text)';
        }
        field(7; "Value (Integer)"; Integer)
        {
            Caption = 'Value (Integer)';
        }
        field(8; "Value (Date)"; Date)
        {
            Caption = 'Value (Date)';
        }
        field(9; "Value (Decimal)"; Decimal)
        {
            Caption = 'Value (Decimal)';
        }
        field(10; "Value (Boolean)"; Boolean)
        {
            Caption = 'Value (Boolean)';
        }
        field(11; "Value (GUID)"; Guid)
        {
            Caption = 'Value (GUID)';
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
        key(Key2; "Parent ID")
        {
        }
        key(Key3; "Table No.", "Parent ID", "Value (Text)")
        {
        }
        key(Key4; "Table No.", "Parent ID", "Value (Integer)")
        {
        }
        key(Key5; "Table No.", "Parent ID", "Value (Date)")
        {
        }
        key(Key6; "Table No.", "Parent ID", "Value (Decimal)")
        {
        }
        key(Key7; "Table No.", "Parent ID", "Value (Boolean)")
        {
        }
        key(Key8; "Table No.", "Parent ID", "Value (GUID)")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        RecIDTree: Record "CDC Record ID Tree";
    begin
        if RecIDTree.FindLast() then
            ID := RecIDTree.ID + 1
        else
            ID := 1;
    end;
}

