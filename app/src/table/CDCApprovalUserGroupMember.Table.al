table 6085631 "CDC Approval User Group Member"
{
    Caption = 'Approval User Group Member';

    fields
    {
        field(1; "Approval User Group Code"; Code[20])
        {
            Caption = 'Approval User Group Code';
            NotBlank = true;
        }
        field(2; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            NotBlank = true;
        }
        field(4; "Approval User Group Name"; Text[50])
        {
            CalcFormula = lookup("CDC Approval User Group".Name where(Code = field("Approval User Group Code")));
            Caption = 'User Group Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Approval User Group Code", "Continia User ID")
        {
            Clustered = true;
        }
        key(Key2; "Continia User ID")
        {
        }
    }
    procedure SetCurrCompanyNameTbl(NewCompanyName: Text[30])
    begin
    end;

    procedure GetCurrCompanyNameTbl(): Text[30]
    begin
    end;

    procedure GetContiniaUserSetup(NewCompanyName: Text[30])
    begin
    end;
}