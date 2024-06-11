table 6086110 "CDC Template Upg."
{
    Caption = 'Template Upg.';
    DataCaptionFields = "No.", Type;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; "Category Code"; Code[10])
        {
            Caption = 'Category Code';
        }
        field(5; "Source Record ID Tree ID"; Integer)
        {
            Caption = 'Source Record ID Tree ID';
        }
        field(6; Default; Boolean)
        {
            Caption = 'Default';
        }
        field(7; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Identification,Master';
            OptionMembers = " ",Identification,Master;
        }
        field(9; "Recognize Lines"; Option)
        {
            Caption = 'Recognize Lines';
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(19; "Search Text"; Code[200])
        {
            Caption = 'Search Text';
        }
        field(44; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(45; "Source Record Table ID"; Integer)
        {
            Caption = 'Source Record Table ID';
        }
        field(46; "Source Record No."; Code[50])
        {
            Caption = 'Source Record No.';
        }
        field(47; "Source Record Name"; Text[100])
        {
            Caption = 'Source Record Name';
        }
        field(1060; "New field config (manual)"; Boolean)
        {
            Caption = 'New field config (manual)';
        }
        field(1061; "New field config (auto)"; Boolean)
        {
            Caption = 'New field config (auto)';
        }
        field(1062; Ignore; Boolean)
        {
            Caption = 'Ignore';
        }
        field(1063; Upgraded; Boolean)
        {
            Caption = 'Upgraded';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Category Code", Type)
        {
        }
        key(Key3; "Search Text")
        {
        }
        key(Key4; "Category Code", "Source Record ID Tree ID")
        {
        }
        key(Key5; "Source Record Table ID", "Source Record No.", "Category Code")
        {
        }
    }
}