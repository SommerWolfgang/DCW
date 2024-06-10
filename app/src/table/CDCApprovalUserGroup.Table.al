table 6085630 "CDC Approval User Group"
{
    Caption = 'Approval User Group';
    DataCaptionFields = "Code", Name;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }
    procedure GetCurrCompanyNameTbl(): Text[30]
    begin
    end;

    procedure IsUserMember(UserID: Code[50]): Boolean
    begin
    end;

    procedure SetUserGroupMembership(UserID: Code[50]; NewUserGroupMembership: Boolean)
    begin
    end;
}