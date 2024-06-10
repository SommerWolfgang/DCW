table 6086111 "CDC Template Field Upg."
{
    Caption = 'Template Field Upg.';

    fields
    {
        field(1; "Template No."; Code[20])
        {
            Caption = 'Template No.';
            NotBlank = true;
            TableRelation = "CDC Template";
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
            NotBlank = true;
        }
        field(4; "Data Type"; Option)
        {
            Caption = 'Data Type';
            OptionCaption = 'Text,Number,Date,Boolean,,,,,Lookup';
            OptionMembers = Text,Number,Date,Boolean,,,,,_Lookup;
        }
        field(32; "Field Name"; Text[50])
        {
            Caption = 'Field Name';
        }
        field(46; "G/L Account Field Code"; Code[20])
        {
            Caption = 'G/L Account Field Code';
        }
        field(47; "Transfer Amount to Document"; Option)
        {
            Caption = 'Transfer Amount to Document';
            OptionCaption = ' ,If lines are not recognised,Always';
            OptionMembers = " ","If lines are not recognised",Always;
        }
        field(48; "Subtract from Amount Field"; Code[20])
        {
            Caption = 'Subtract from Amount Field (on registration)';
        }
        field(1046; "New G/L Account Field Code"; Code[20])
        {
            Caption = 'New G/L Account Field Code';
        }
        field(1047; "New Transfer Amt. to Document"; Option)
        {
            Caption = 'New Transfer Amount to Document';
            OptionCaption = ' ,If lines are not recognised,Always';
            OptionMembers = " ","If lines are not recognised",Always;
        }
        field(1048; "New Subtract from Amount Field"; Code[20])
        {
            Caption = 'New Subtract from Amount Field (on registration)';
        }
    }

    keys
    {
        key(Key1; "Template No.", Type, "Code")
        {
            Clustered = true;
        }
    }
}