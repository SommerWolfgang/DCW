table 6086404 "CEM User Delegation"
{
    Caption = 'Expense User Delegation';
    LookupPageID = "CEM User Delegation";
    Permissions = TableData "CEM User Delegation" = rimd;

    fields
    {
        field(1; "Owner User ID"; Code[50])
        {
            Caption = 'Owner User ID';
            NotBlank = true;
            TableRelation = "CDC Continia User Setup" WHERE("Expense Management User" = CONST(true));
        }
        field(2; "Delegated User ID"; Code[50])
        {
            Caption = 'Delegated User ID';
            NotBlank = true;
            TableRelation = "CDC Continia User Setup" WHERE("Expense Management User" = CONST(true));
        }
        field(3; "Valid From"; Date)
        {
            Caption = 'Valid From';
        }
        field(4; "Valid To"; Date)
        {
            Caption = 'Valid To';
        }
    }

    keys
    {
        key(Key1; "Owner User ID", "Delegated User ID", "Valid From", "Valid To")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        UserIDBlankErr: Label 'Continia User ID must not be blank.';
        UserNotDelegatedErr: Label 'You are not delegated for handling documents for %1. Please contact your system administrator.';


    procedure GetDelegationFilter() FilterTxt: Text[1024]
    var
        UserDelegation: Record "CEM User Delegation";
    begin
        if not IsNAVUser then
            exit;

        FilterTxt := UserId;

        UserDelegation.SetRange("Delegated User ID", UserId);
        UserDelegation.SetRange("Valid From", 0D, Today);
        UserDelegation.SetFilter("Valid To", '=%1|>=%2', 0D, Today);
        if UserDelegation.FindSet then
            repeat
                FilterTxt := FilterTxt + '|' + UserDelegation."Owner User ID";
            until UserDelegation.Next = 0;
    end;


    procedure GetDelegatedUsersFilter(OwnerUserID: Code[50]) FilterTxt: Text[1024]
    var
        UserDelegation: Record "CEM User Delegation";
    begin
        UserDelegation.SetRange("Owner User ID", OwnerUserID);
        UserDelegation.SetRange("Valid From", 0D, Today);
        UserDelegation.SetFilter("Valid To", '=%1|>=%2', 0D, Today);
        if UserDelegation.FindSet then
            repeat
                if FilterTxt = '' then
                    FilterTxt := UserDelegation."Delegated User ID"
                else
                    FilterTxt := FilterTxt + '|' + UserDelegation."Delegated User ID";
            until UserDelegation.Next = 0;
    end;


    procedure LookupUser2(var Text: Text[1024]; var ContiniaUserSetup: Record "CDC Continia User Setup"): Boolean
    begin
        ContiniaUserSetup.SetFilter("Continia User ID", GetDelegationFilter);
        if ContiniaUserSetup.Get(Text) then;
        if PAGE.RunModal(0, ContiniaUserSetup) = ACTION::LookupOK then begin
            Text := ContiniaUserSetup."Continia User ID";
            exit(true);
        end;
    end;


    procedure LookupUser(var Text: Text[1024]): Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        exit(LookupUser2(Text, ContiniaUserSetup));
    end;


    procedure VerifyUser(var DelegatedUserID: Code[50])
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        if DelegatedUserID = '' then
            Error(UserIDBlankErr);

        if GetDelegationFilter = '' then
            exit;

        ContiniaUserSetup.SetFilter("Continia User ID", GetDelegationFilter);
        if ContiniaUserSetup.FindSet then
            repeat
                if ContiniaUserSetup."Continia User ID" = DelegatedUserID then
                    exit;
            until ContiniaUserSetup.Next = 0
        else
            exit;

        Error(UserNotDelegatedErr, DelegatedUserID);
    end;


    procedure IsNAVUser(): Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        EMSetup: Record "CEM Expense Management Setup";
    begin
        if not EMSetup.Get then
            exit(false);

        ContiniaUserSetup.SetRange("Continia User ID", UserId);
        ContiniaUserSetup.SetRange("Limit Document Visibility", true);
        exit(not ContiniaUserSetup.IsEmpty);
    end;


    procedure GetDelegationNames() FilterTxt: Text[1024]
    var
        UserDelegation: Record "CEM User Delegation";
        ApprovalMgt: Codeunit "CDC Approval Management";
        StopLoop: Boolean;
    begin
        if not IsNAVUser then
            exit;

        UserDelegation.SetRange("Delegated User ID", UserId);
        if UserDelegation.FindSet then
            repeat
                if UserDelegation."Owner User ID" <> UserId then
                    if (StrLen(ApprovalMgt.GetApproverDisplayName(UserDelegation."Owner User ID")) +
                      StrLen(FilterTxt) + 2) >= 1024 then
                        StopLoop := true
                    else begin
                        if FilterTxt = '' then
                            FilterTxt := ApprovalMgt.GetApproverDisplayName(UserDelegation."Owner User ID")
                        else
                            FilterTxt := FilterTxt + ', ' + ApprovalMgt.GetApproverDisplayName(UserDelegation."Owner User ID");
                    end;
            until (UserDelegation.Next = 0) or StopLoop;
    end;


    procedure GetUserName(ContiniaUserID: Code[50]): Text[50]
    var
        ContiniaUser: Record "CDC Continia User";
    begin
        if ContiniaUserID = '' then
            exit;

        if ContiniaUser.Get(ContiniaUserID) then
            if ContiniaUser.Name <> '' then
                exit(ContiniaUser.Name);

        exit(ContiniaUser."User ID");
    end;


    procedure IsValid(): Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        if "Owner User ID" = '' then
            exit(false);

        if "Delegated User ID" = '' then
            exit(false);

        if not ContiniaUserSetup.Get("Owner User ID") then
            exit(false);

        if not ContiniaUserSetup."Expense Management User" then
            exit(false);

        if not ContiniaUserSetup.Get("Delegated User ID") then
            exit(false);

        if not ContiniaUserSetup."Expense Management User" then
            exit(false);

        if "Owner User ID" = "Delegated User ID" then
            exit(false);

        if not PeriodIsValid("Valid From", "Valid To") then
            exit(false);

        exit(true);
    end;


    procedure PeriodIsValid(StartDate: Date; EndDate: Date): Boolean
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
            exit(true);

        exit(StartDate <= EndDate);
    end;
}

