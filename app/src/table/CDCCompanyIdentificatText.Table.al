table 6085611 "CDC Company Identificat. Text"
{
    Caption = 'Company Identification Text';
    DataPerCompany = false;

    fields
    {
        field(1; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            NotBlank = true;
            TableRelation = Company;
        }
        field(2; "Identification Text"; Text[150])
        {
            Caption = 'Identification Text';
            NotBlank = true;

            trigger OnValidate()
            begin
                "Identification Text Length" := StrLen("Identification Text");
            end;
        }
        field(3; "Identification Text Length"; Integer)
        {
            Caption = 'Identification Text Length';
        }
    }

    keys
    {
        key(Key1; "Company Name", "Identification Text")
        {
            Clustered = true;
        }
        key(Key2; "Identification Text Length")
        {
        }
    }

    fieldgroups
    {
    }
}

