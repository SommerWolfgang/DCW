table 6085725 "CDC Approval Flow"
{
    Caption = 'Approval Flow';

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
        field(3; "No. of Approvers"; Integer)
        {
            CalcFormula = count("CDC Approval Flow Line" where("Approval Flow Code" = field(Code)));
            Caption = 'No. of Approvers';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
}