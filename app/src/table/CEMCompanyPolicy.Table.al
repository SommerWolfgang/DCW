table 6086403 "CEM Company Policy"
{
    Caption = 'Company Policy';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = " ",Mileage,Expense,"Per Diem";
        }
        field(2; "Document Account No."; Code[20])
        {
            Caption = 'Document Account No.';
            TableRelation = IF ("Document Type" = CONST(Expense)) "CEM Expense Type"
            ELSE
            IF ("Document Type" = CONST(Mileage)) "CEM Vehicle"
            ELSE
            IF ("Document Type" = CONST("Per Diem")) "CEM Allowance";
        }
        field(3; "User Type"; Option)
        {
            Caption = 'User Type';
            OptionMembers = User,"User Group";
        }
        field(4; "User Code"; Code[50])
        {
            Caption = 'User Code';
            NotBlank = true;
            TableRelation = IF ("User Type" = CONST(User)) "CDC Continia User Setup"
            ELSE
            IF ("User Type" = CONST("User Group")) "CEM Expense User Group";
        }
        field(5; "Action"; Option)
        {
            Caption = 'Action';
            OptionCaption = 'Automatically approve documents below the limit,Refund the document up to the limit,Add a warning comment when above limit';
            OptionMembers = "Approve below","Refund within limit","Warning above";

            trigger OnValidate()
            begin
                if Action = Action::"Refund within limit" then
                    if "Period of Time" <> "Period of Time"::" " then
                        Error(PartialRefundErr, FieldCaption("Period of Time"));
            end;
        }
        field(6; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(7; "Period of Time"; Option)
        {
            Caption = 'Period of Time';
            OptionCaption = ' ,Day,Week,Month,Year';
            OptionMembers = " ",Day,Week,Month,Year;

            trigger OnValidate()
            begin
                if Action = Action::"Refund within limit" then
                    if "Period of Time" <> "Period of Time"::" " then
                        Error(PartialRefundErr, FieldCaption("Period of Time"));
            end;
        }
        field(8; Distance; Decimal)
        {
            Caption = 'Distance';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document Account No.", "User Type", "User Code", "Action")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PartialRefundErr: Label 'Partial refund is only allowed when there is no %1 specified.';


    procedure GetWarningCommentPolicy(TableID: Integer; ContiniaUserID: Code[50]; DocAccountNo: Code[20]): Boolean
    var
        LimitSetup: Record "CEM Company Policy";
    begin
        exit(FindCompanyPolicy(TableID, DocAccountNo, ContiniaUserID, Action::"Warning above"));
    end;


    procedure GetApproveBelowPolicy(TableID: Integer; ContiniaUserID: Code[50]; DocAccountNo: Code[20]): Boolean
    var
        LimitSetup: Record "CEM Company Policy";
    begin
        exit(FindCompanyPolicy(TableID, DocAccountNo, ContiniaUserID, Action::"Approve below"));
    end;


    procedure GetRefundWithinPolicy(TableID: Integer; ContiniaUserID: Code[50]; DocAccountNo: Code[20]): Boolean
    var
        LimitSetup: Record "CEM Company Policy";
    begin
        exit(FindCompanyPolicy(TableID, DocAccountNo, ContiniaUserID, Action::"Refund within limit"))
    end;


    procedure GetTimeIntervalStartAndEndDate(DocumentDate: Date; var StartDate: Date; var EndDate: Date): Integer
    begin
        if DocumentDate = 0D then
            DocumentDate := Today;

        case "Period of Time" of
            "Period of Time"::" ":
                begin
                    StartDate := 0D;
                    EndDate := 0D;
                end;

            "Period of Time"::Day:
                begin
                    StartDate := DocumentDate;
                    EndDate := DocumentDate;
                end;

            "Period of Time"::Week:
                begin
                    StartDate := CalcDate('<-CW>', DocumentDate);
                    EndDate := CalcDate('<CW>', DocumentDate);
                end;

            "Period of Time"::Month:
                begin
                    StartDate := CalcDate('<-CM>', DocumentDate);
                    EndDate := CalcDate('<CM>', DocumentDate);
                end;

            "Period of Time"::Year:
                begin
                    StartDate := CalcDate('<-CY>', DocumentDate);
                    EndDate := CalcDate('<CY>', DocumentDate);
                end;
            else
                Error('Not supported');
        end;
    end;


    procedure FindCompanyPolicy(TableID: Integer; DocAccountNo: Code[20]; ContiniaUserID: Code[50]; ActionFilter: Option "Approve below","Refund within limit","Warning above","Do not allow above"): Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        LimitSetup: Record "CEM Company Policy";
        DocumentType: Option " ",Mileage,Expense,"Per Diem";
    begin
        case TableID of
            DATABASE::"CEM Expense":
                DocumentType := DocumentType::Expense;
            DATABASE::"CEM Mileage":
                DocumentType := DocumentType::Mileage;
            DATABASE::"CEM Per Diem":
                DocumentType := DocumentType::"Per Diem";
        end;

        if not ContiniaUserSetup.Get(ContiniaUserID) then
            exit;

        // Priority 1: Find a limit with perfect match
        if LimitSetup.Get(DocumentType, DocAccountNo, LimitSetup."User Type"::User, ContiniaUserID, ActionFilter) then begin
            Rec := LimitSetup;
            exit(true);
        end;

        if LimitSetup.Get(DocumentType, DocAccountNo,
          LimitSetup."User Type"::"User Group", ContiniaUserSetup."Expense User Group", ActionFilter)
        then begin
            Rec := LimitSetup;
            exit(true);
        end;

        if LimitSetup.Get(DocumentType::" ", '',
          LimitSetup."User Type"::"User Group", ContiniaUserSetup."Expense User Group", ActionFilter)
        then begin
            Rec := LimitSetup;
            exit(true);
        end;
    end;


    procedure LoadCompanyPolicyForUser(ContiniaUserID: Code[50]; var LimitSetupTemp: Record "CEM Company Policy" temporary)
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        LimitSetup: Record "CEM Company Policy";
    begin
        LimitSetup.SetRange("User Type", LimitSetup."User Type"::User);
        LimitSetup.SetRange("User Code", ContiniaUserID);
        if LimitSetup.FindSet then
            repeat
                LimitSetupTemp.Copy(LimitSetup);
                LimitSetupTemp.Insert;
            until LimitSetup.Next = 0;

        // Find Limit Setup on a User Group level but do not overwrite
        if ContiniaUserSetup.Get(ContiniaUserID) then begin
            LimitSetup.SetRange("User Type", LimitSetup."User Type"::"User Group");
            LimitSetup.SetRange("User Code", ContiniaUserSetup."Expense User Group");
            if LimitSetup.FindSet then
                repeat
                    LimitSetupTemp.Copy(LimitSetup);
                    if not LimitSetupTemp.Insert then; // If the limit already exists, do not alter it.
                until LimitSetup.Next = 0;
        end;
    end;


    procedure GetLimitBalanceForUser(ContiniaUserID: Code[50]; LimitSetup: Record "CEM Company Policy" temporary): Decimal
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        EndDate: Date;
        StartDate: Date;
    begin
        LimitSetup.GetTimeIntervalStartAndEndDate(Today, StartDate, EndDate);

        case LimitSetup."Document Type" of
            LimitSetup."Document Type"::Expense:
                begin
                    if (StartDate <> 0D) and (EndDate <> 0D) then begin
                        Expense.SetCurrentKey("Continia User ID", "Document Date", "Expense Type");
                        Expense.SetRange("Continia User ID", ContiniaUserID);
                        Expense.SetRange("Document Date", StartDate, EndDate);
                        Expense.SetRange("Expense Type", LimitSetup."Document Account No.");
                        Expense.CalcSums("Amount (LCY)");
                    end else
                        Expense.CalcSums("Amount (LCY)");
                    exit(Expense."Amount (LCY)");
                end;

            LimitSetup."Document Type"::Mileage:
                begin
                    if (StartDate <> 0D) and (EndDate <> 0D) then begin
                        Mileage.SetCurrentKey("Continia User ID", "Registration Date", "Vehicle Code");
                        Mileage.SetRange("Continia User ID", ContiniaUserID);
                        Mileage.SetRange("Registration Date", StartDate, EndDate);
                        Mileage.SetRange("Vehicle Code", LimitSetup."Document Account No.");
                        Mileage.CalcSums("Total Distance");
                    end else
                        Mileage.CalcSums("Total Distance");
                end;
        end;
    end;
}

