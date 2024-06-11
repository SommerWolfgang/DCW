table 6085766 "CDC Auto Split Page"
{
    Caption = 'Auto Split Page';

    fields
    {
        field(1; "Page No."; Integer)
        {
            Caption = 'Page No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Page Type"; Option)
        {
            Caption = 'Page Type';
            OptionCaption = 'Normal,Split,Blank';
            OptionMembers = Normal,Split,Blank;
        }
        field(4; "Last Page No."; Integer)
        {
            Caption = 'Page No.';
        }
    }

    keys
    {
        key(Key1; "Page No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

