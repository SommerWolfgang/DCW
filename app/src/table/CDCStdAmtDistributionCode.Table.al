table 6085774 "CDC Std. Amt Distribution Code"
{
    Caption = 'Standard Amount Distribution Code';

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Enabled for Purchase"; Option)
        {
            Caption = 'Enabled for Purchase';
            InitValue = "Yes - all vendors";
            OptionCaption = 'No,Yes - all vendors,Yes - selected vendors only';
            OptionMembers = No,"Yes - all vendors","Yes - selected vendors only";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    procedure ShowVendors()
    begin
    end;
}