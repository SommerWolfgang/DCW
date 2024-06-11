table 6085593 "CDC Document Value"
{
    Caption = 'Document Value';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Page No."; Integer)
        {
            Caption = 'Page No.';
        }
        field(6; Top; Integer)
        {
            Caption = 'Top';
        }
        field(7; Left; Integer)
        {
            Caption = 'Left';
        }
        field(8; Bottom; Integer)
        {
            Caption = 'Bottom';
        }
        field(9; Right; Integer)
        {
            Caption = 'Right';
        }
        field(10; "Template No."; Code[20])
        {
            Caption = 'Template No.';
        }
        field(11; "Is Value"; Boolean)
        {
            Caption = 'Is Value';
        }
        field(12; "Is Valid"; Boolean)
        {
            Caption = 'Is Valid';
        }
        field(20; "Value (Text)"; Text[250])
        {
            Caption = 'Value (Text)';
        }
        field(21; "Value (Decimal)"; Decimal)
        {
            Caption = 'Value (Decimal)';
        }
        field(22; "Value (Date)"; Date)
        {
            Caption = 'Value (Date)';
        }
        field(23; "Value (Record ID Tree ID)"; Integer)
        {
            Caption = 'Value (Record ID Tree ID)';
        }
        field(24; "Value (Blob)"; BLOB)
        {
            Caption = 'Value (Blob)';
        }
        field(40; "Lookup Table"; Option)
        {
            Caption = 'Lookup Table';
            OptionCaption = ' ,Vendor,Contact,Customer,Job,Item,Fixed Asset,Employee,Dimension Value,Field Specific Value';
            OptionMembers = " ",Vendor,Contact,Customer,Job,Item,"Fixed Asset",Employee,"Dimension Value","Field Specific Value";
        }
        field(41; "Value (Lookup)"; Code[20])
        {
            Caption = 'Value (Lookup)';
        }
        field(42; "Value (Rel. Code)"; Code[20])
        {
            Caption = 'Value (Rel. Code)';
        }
        field(43; "Value (Boolean)"; Boolean)
        {
            Caption = 'Value (Boolean)';
        }
        field(44; "Updated By User"; Boolean)
        {
            Caption = 'Updated By User';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Is Value", "Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Template No.", "Is Value", Type, "Code")
        {
        }
        key(Key3; "Document No.", "Is Value", Type, "Page No.", "Line No.", "Code")
        {
        }
        key(Key4; "Document No.", "Is Value", Type, "Line No.")
        {
        }
        key(Key5; "Value (Record ID Tree ID)", Type, "Code", "Line No.")
        {
        }
    }
    procedure IsBlank(): Boolean
    begin
    end;

    procedure HasFullRect(): Boolean
    begin
    end;

    procedure GetFullText() Text: Text
    begin
    end;

    procedure IsEqual(Value: Record "CDC Document Value"): Boolean
    begin
    end;
}