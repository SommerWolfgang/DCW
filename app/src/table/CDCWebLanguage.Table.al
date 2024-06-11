table 6086007 "CDC Web Language"
{
    Caption = 'Web Language';
    DataPerCompany = false;

    fields
    {
        field(1; Name; Text[50])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; Enabled; Boolean)
        {
            Caption = 'Enabled';
        }
        field(4; "Display Sort Order"; Integer)
        {
            Caption = 'Display Sort Order';
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
        key(Key2; "Display Sort Order")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnRename()
    begin
        Error(Text001, TableCaption);
    end;

    var
        Text001: Label 'You cannot rename a %1.';
}

