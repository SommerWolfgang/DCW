table 6086339 "CEM Expense Header"
{
    Caption = 'Settlement';
    DataCaptionFields = "No.", "Continia User ID", Description;
    Permissions = TableData "Sales & Receivables Setup" = r,
                  TableData "CDC Continia User Setup" = r,
                  TableData "CEM Expense Management Setup" = r,
                  TableData "CEM Expense Header Inbox" = r;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Budget,Settlement';
            OptionMembers = Budget,Settlement;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if "No." <> xRec."No." then begin
                    EMSetup.Get();
                    NoSeriesMgt.TestManual(EMSetup."Settlement Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(3; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup";

            trigger OnValidate()
            var
                ContiniaUser: Record "CDC Continia User";
                UserDelegation: Record "CEM User Delegation";
            begin
                CheckLinesExist();

                if "Continia User ID" <> '' then
                    ContiniaUser.Get("Continia User ID")
                else
                    Clear(ContiniaUser);

                "Continia User Name" := ContiniaUser.Name;
                AddDefaultDim(CurrFieldNo);

                UserDelegation.VerifyUser("Continia User ID");
            end;
        }
        field(4; "Continia User Name"; Text[50])
        {
            Caption = 'Name';
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(6; "Date Created"; Date)
        {
            Caption = 'Date Created';
            Editable = false;
        }
        field(7; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(8; "Created by User ID"; Code[50])
        {
            Caption = 'Created by User ID';
            Editable = false;
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
        }
        field(11; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;

            trigger OnValidate()
            begin
                AddDefaultDim(CurrFieldNo);
                if "Job No." = '' then
                    Validate("Job Task No.", '');
                Validate(Billable, "Job Task No." <> '');
            end;
        }
        field(12; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));

            trigger OnValidate()
            begin
                Validate(Billable, "Job Task No." <> '');
                AddDefaultDim(CurrFieldNo);
            end;
        }
        field(13; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending Expense User,Pending Approval,Released';
            OptionMembers = Open,"Pending Expense User","Pending Approval",Released;
        }
        field(14; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
        }
        field(15; "Posted Date/Time"; DateTime)
        {
            Caption = 'Posted Date Time';
            Editable = false;
        }
        field(16; "Posted by User ID"; Code[50])
        {
            Caption = 'Posted by User ID';
            Editable = false;
        }
        field(17; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
        field(19; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(20; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(21; "Exp. Header GUID"; Guid)
        {
            Caption = 'Exp. Header GUID';
        }
        field(22; Comment; Boolean)
        {
            CalcFormula = exist("CEM Comment Line" where("Table Name" = const("Expense Header"),
                                                          "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            NotBlank = true;
            TableRelation = "CEM Country/Region";
        }
        field(24; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(25; "Expense Header Completed"; Boolean)
        {
            Caption = 'Settlement Completed';
        }
        field(26; "Continia Online Version No."; Text[100])
        {
            Caption = 'Continia Online Version No.';
        }
        field(27; "Departure Date/Time"; DateTime)
        {
            Caption = 'Departure Date/Time';
        }
        field(28; "Return Date/Time"; DateTime)
        {
            Caption = 'Return Date/Time';
        }
        field(30; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(33; Billable; Boolean)
        {
            Caption = 'Billable';

            trigger OnValidate()
            begin
                if Billable and ("Job No." <> '') and ("Job Task No." <> '') then
                    Validate("Job Line Type", "Job Line Type"::Contract)
                else
                    Validate("Job Line Type", "Job Line Type"::" ");
            end;
        }
        field(34; "Job Line Type"; Option)
        {
            Caption = 'Job Line Type';
            OptionCaption = ' ,Budget,Billable,Both Budget and Billable';
            OptionMembers = " ",Schedule,Contract,"Both Schedule and Contract";

            trigger OnValidate()
            begin
                if "Job Line Type" = "Job Line Type"::Contract then begin
                    TestField("Job No.");
                    TestField("Job Task No.");
                end;
            end;
        }
        field(40; "Posting Description"; Text[30])
        {
            Caption = 'Posting Description';
        }
        field(41; "Notification Type"; Option)
        {
            Caption = 'Notification Type';
            OptionMembers = " ","New document","Important update","New history status","New pre-approval state";
        }
        field(50; "Pre-approval Amount"; Decimal)
        {
            Caption = 'Pre-approval Amount (LCY)';
        }
        field(51; "Pre-approval Status"; Option)
        {
            Caption = 'Pre-approval Status';
            OptionMembers = " ",Pending,Approved,Rejected;
        }
        field(65; "Employee Reimbursed"; Boolean)
        {
            Caption = 'Employee Reimbursed';
        }
        field(101; "Mileage Total (LCY)"; Decimal)
        {
            CalcFormula = sum("CEM Mileage"."Amount (LCY)" where("Settlement No." = field("No.")));
            Caption = 'Mileage Total (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(113; "Created Doc. Type"; Integer)
        {
            Caption = 'Created Doc. Type';
            Editable = false;
        }
        field(114; "Created Doc. Subtype"; Integer)
        {
            Caption = 'Created Doc. Subtype';
            Editable = false;
        }
        field(115; "Created Doc. ID"; Code[20])
        {
            Caption = 'Created Doc. ID';
            Editable = false;
        }
        field(116; "Created Doc. Ref. No."; Integer)
        {
            Caption = 'Created Doc. Ref. No.';
            Editable = false;
        }
        field(117; "Updated By Delegation User"; Code[50])
        {
            Caption = 'Updated By Delegation User';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
        key(Key2; "Exp. Header GUID")
        {
        }
        key(Key3; "Continia User ID", Status)
        {
        }
        key(Key4; Posted, "Continia User ID", Status)
        {
        }
        key(Key5; "Created Doc. Type", "Created Doc. Subtype", "Created Doc. ID", "Created Doc. Ref. No.")
        {
        }
        key(Key6; Posted, "Posted Date/Time", "Document Type", "No.")
        {
        }
    }

    procedure AssistEditNoSeries(OldExpHeader: Record "CEM Expense Header"): Boolean
    begin
    end;

    procedure LinesExist(): Boolean
    begin
    end;

    procedure SetSkipSendToExpUser(NewSkipSendToExpUser: Boolean)
    begin
    end;

    procedure SendToExpenseUser()
    begin
    end;

    procedure GetOverviewDetails() AddInfo: Text[1024]
    begin
    end;

    procedure LookupDimensions()
    begin
    end;

    procedure LookupExtraFields()
    begin
    end;

    procedure AddDefaultDim(ValidatedFieldNo: Integer)
    begin
    end;

    procedure GetPerDiemTotalLCY(): Decimal
    begin
    end;

    procedure GetAmountLCY(): Decimal
    begin
    end;

    procedure GetDataCaption(): Text[250]
    begin
        exit(Format("Document Type") + ' ' + "No.");
    end;


    procedure ExistsInInbox(ShowError: Boolean): Boolean
    begin
    end;

    procedure CheckInboxAndThrowError()
    begin
    end;

    procedure ThrowInboxError()
    begin
    end;

    procedure Navigate()
    begin
    end;

    procedure HasApprovalComment(): Boolean
    var
        ApprovalCmtLine: Record "Approval Comment Line";
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        ApprovalCmtLine.SetCurrentKey("Table ID", "Document Type", "Document No.");
        ApprovalCmtLine.SetRange("Table ID", DATABASE::"CEM Expense Header");
        ApprovalCmtLine.SetRange("Document Type", ApprovalCmtLine."Document Type"::Invoice);
        ApprovalCmtLine.SetRange("Document No.", "No.");
        if not ApprovalCmtLine.IsEmpty then
            exit(true);

        Expense.SetCurrentKey("Settlement No.");
        Expense.SetRange("Settlement No.", "No.");
        if Expense.FindSet() then
            repeat
                if Expense.HasApprovalComment() then
                    exit(true);
            until Expense.Next() = 0;

        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", "No.");
        if Mileage.FindSet() then
            repeat
                if Mileage.HasApprovalComment() then
                    exit(true);
            until Mileage.Next() = 0;

        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", "No.");
        if PerDiem.FindSet() then
            repeat
                if PerDiem.HasApprovalComment() then
                    exit(true);
            until PerDiem.Next() = 0;
    end;


    procedure HasSettlementComment(): Boolean
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        CalcFields(Comment);
        if Comment then
            exit(true);

        Expense.SetCurrentKey("Settlement No.");
        Expense.SetRange("Settlement No.", "No.");
        if Expense.FindSet() then
            repeat
                if Expense.HasExpenseComment() then
                    exit(true);
            until Expense.Next() = 0;

        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", "No.");
        if Mileage.FindSet() then
            repeat
                if Mileage.HasMileageComment() then
                    exit(true);
            until Mileage.Next() = 0;

        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", "No.");
        if PerDiem.FindSet() then
            repeat
                if PerDiem.HasPerDiemComment() then
                    exit(true);
            until PerDiem.Next() = 0;
    end;

    procedure HasErrorComment(ShowFirstError: Boolean; RunValidationChecks: Boolean): Boolean
    begin
    end;

    procedure HasWarningComment(ShowFirstError: Boolean): Boolean
    begin
    end;

    procedure CheckUnProcessedInbox()
    begin
    end;

    procedure UpdatePostingDate(PostingDatePolicy: Option FirstDate,LastDate)
    begin
    end;

    procedure CalcPostingDateBasedOnPolicy(PostingDatePolicy: Option FirstDate,LastDate; PostingDateToCheck: Date; var NewPostingDate: Date)
    begin
        if PostingDatePolicy = PostingDatePolicy::FirstDate then
            if (NewPostingDate = 0D) or (NewPostingDate > PostingDateToCheck) then
                NewPostingDate := PostingDateToCheck;

        if PostingDatePolicy = PostingDatePolicy::LastDate then
            if (NewPostingDate = 0D) or (NewPostingDate < PostingDateToCheck) then
                NewPostingDate := PostingDateToCheck;
    end;


    procedure AttachExpensesToSettlement()
    begin
    end;

    procedure AttachMileageToSettlement()
    begin
    end;

    procedure AttachPerDiemToSettlement()
    begin
    end;

    procedure SetHideUI()
    begin
    end;

    procedure NextReminderDate(): Date
    var
        EMReminder: Record "CEM Reminder";
    begin
        exit(
          EMReminder.NextReminderDate(
            "Continia User ID", DATABASE::"CEM Expense Header", "Document Type"::Settlement, "No.", 0, FirstDocumentDate()));
    end;


    procedure SetSuspendInboxCheck(NewSuspend: Boolean)
    begin
    end;

    local procedure CheckLinesExist()
    begin
    end;

    local procedure FirstDocumentDate() FirstDate: Date
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
        DocEarliestDate: Date;
    begin
        FirstDate := "Date Created";

        Expense.SetCurrentKey("Settlement No.");
        Expense.SetRange("Settlement No.", "No.");
        if Expense.FindSet() then
            repeat
                DocEarliestDate := Expense.GetEarliestDate();
                if (DocEarliestDate <> 0D) and (DocEarliestDate < FirstDate) then
                    FirstDate := DocEarliestDate;
            until Expense.Next() = 0;

        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", "No.");
        if Mileage.FindSet() then
            repeat
                DocEarliestDate := Mileage.GetEarliestDate();
                if (DocEarliestDate <> 0D) and (DocEarliestDate < FirstDate) then
                    FirstDate := DocEarliestDate;
            until Mileage.Next() = 0;

        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", "No.");
        if PerDiem.FindSet() then
            repeat
                DocEarliestDate := PerDiem.GetEarliestDate();
                if (DocEarliestDate <> 0D) and (DocEarliestDate < FirstDate) then
                    FirstDate := DocEarliestDate;
            until PerDiem.Next() = 0;
    end;


    procedure GetTableCaptionSingular(): Text[250]
    begin
    end;


    procedure GetTableCaptionPlural(): Text[250]
    begin
    end;


    procedure AllocationExists(): Boolean
    var
        Expense: Record "CEM Expense";
        PerDiem: Record "CEM Per Diem";
    begin
        Expense.SetRange("Settlement No.", "No.");
        if Expense.FindSet() then
            repeat
                if Expense.AllocationExists() then
                    exit(true);
            until Expense.Next() = 0;

        PerDiem.SetRange("Settlement No.", "No.");
        if not PerDiem.IsEmpty then
            exit(true);
    end;

    procedure GetSettlementReadyToAppend(SettlementGUID: Guid; var ExpHeader: Record "CEM Expense Header")
    begin
    end;

    procedure EmployeeReimbExpectedInBC(): Boolean
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        Expense.SetCurrentKey("Settlement No.");
        Expense.SetRange("Settlement No.", "No.");
        if Expense.FindSet() then
            repeat
                if Expense.EmployeeReimbExpectedInBC() then
                    exit(true);
            until Expense.Next() = 0;

        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", "No.");
        if Mileage.FindSet() then
            repeat
                if Mileage.EmployeeReimbExpectedInBC() then
                    exit(true);
            until Mileage.Next() = 0;

        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", "No.");
        if PerDiem.FindSet() then
            repeat
                if PerDiem.EmployeeReimbExpectedInBC() then
                    exit(true);
            until PerDiem.Next() = 0;
    end;


    procedure IsPreApprovalRequest(): Boolean
    begin
        exit((not LinesExist()) and ("Pre-approval Status" = "Pre-approval Status"::Pending));
    end;


    procedure IsPreApproved(): Boolean
    begin
        exit("Pre-approval Status" = "Pre-approval Status"::Approved);
    end;


    procedure IsAmountWithinPreApproval(): Boolean
    begin
        if ("Pre-approval Status" = "Pre-approval Status"::Approved) and ("Pre-approval Amount" > 0) then
            exit(GetAmountLCY() <= "Pre-approval Amount");
    end;


    procedure GetEmployeeEmailDep(): Text[250]
    begin
    end;


    procedure ReopenSettlements(var Settlement: Record "CEM Expense Header")
    begin
    end;


    procedure TestStatusOpenOrPendingExpUser()
    begin
        TestStatusAllowsChange();
    end;


    procedure StatusAllowsChange() Condition: Boolean
    begin
    end;


    procedure StatusOrUserAllowsChange() Condition: Boolean
    begin
    end;

    procedure TestStatusAllowsChange()
    begin
    end;

    procedure TestStatusOrUserAllowsChange()
    begin
    end;


    procedure NextApprover(): Code[50]
    begin
    end;


    procedure CurrentUserIsNextApprover(): Boolean
    begin
        exit(UserId = NextApprover());
    end;


    procedure OpenDocumentCard()
    begin
    end;
}