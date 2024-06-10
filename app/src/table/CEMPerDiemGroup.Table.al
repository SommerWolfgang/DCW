table 6086383 "CEM Per Diem Group"
{
    Caption = 'Per Diem Group';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Default; Boolean)
        {
            Caption = 'Default';

            trigger OnValidate()
            var
                PerDiemGroup: Record "CEM Per Diem Group";
            begin
                PerDiemGroup.SetRange(Default, true);
                PerDiemGroup.SetFilter(Code, '<>%1', Code);
                if not PerDiemGroup.IsEmpty then
                    Error(TooManyDefaultErr, TableCaption);
            end;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        PerDiemPostingGroups: Record "CEM Per Diem Posting Group";
    begin
        PerDiemPostingGroups.SetRange("Per Diem Group Code", Code);
        PerDiemPostingGroups.DeleteAll(true);
    end;

    var
        TooManyDefaultErr: Label 'There can only be one default %1.';


    procedure GetDefaultPerDiemGroupCode(User: Code[50]): Code[20]
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        DefaultUserSetup: Record "CEM Default User Setup";
        PerDiemGroup: Record "CEM Per Diem Group";
    begin
        if DefaultUserSetup.Get(DefaultUserSetup."Setup Type"::User, User) then
            if DefaultUserSetup."Per Diem Group Code" <> '' then
                exit(DefaultUserSetup."Per Diem Group Code");

        if ContiniaUserSetup.Get(User) then
            if ContiniaUserSetup."Expense User Group" <> '' then
                if DefaultUserSetup.Get(DefaultUserSetup."Setup Type"::Group, ContiniaUserSetup."Expense User Group") then
                    if DefaultUserSetup."Per Diem Group Code" <> '' then
                        exit(DefaultUserSetup."Per Diem Group Code");

        PerDiemGroup.SetRange(Default, true);
        if PerDiemGroup.FindFirst then
            exit(PerDiemGroup.Code);
    end;
}

