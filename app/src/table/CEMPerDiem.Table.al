table 6086387 "CEM Per Diem"
{
    Caption = 'Per Diem';
    DataCaptionFields = "Entry No.", "Continia User ID", "Per Diem Group Code", Description;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
        }
        field(3; "Continia User Name"; Text[50])
        {
            CalcFormula = lookup("CDC Continia User".Name where("User ID" = field("Continia User ID")));
            Caption = 'Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(6; "Departure Date/Time"; DateTime)
        {
            Caption = 'Departure Date/Time';
            NotBlank = true;
        }
        field(7; "Return Date/Time"; DateTime)
        {
            Caption = 'Return Date/Time';
        }
        field(8; "Date Created"; Date)
        {
            Caption = 'Date Created';
            Editable = false;
        }
        field(9; "Destination Country/Region"; Code[10])
        {
            Caption = 'Destination Country/Region';
            TableRelation = "CEM Country/Region";

            trigger OnValidate()
            begin
                TestStatusAllowsChange();
                Validate("Per Diem Group Code");
            end;
        }
        field(10; "Currency Code"; Code[10])
        {
            CalcFormula = lookup("CEM Per Diem Detail"."Currency Code" where("Per Diem Entry No." = field("Entry No.")));
            Caption = 'Currency Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Currency;
        }
        field(11; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("CEM Per Diem Detail".Amount where("Per Diem Entry No." = field("Entry No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Created Doc. Type"; Integer)
        {
            Caption = 'Created Doc. Type';
            Editable = false;
        }
        field(14; "Created Doc. Subtype"; Integer)
        {
            Caption = 'Created Doc. Subtype';
            Editable = false;
        }
        field(15; "Created Doc. ID"; Code[20])
        {
            Caption = 'Created Doc. ID';
            Editable = false;
        }
        field(16; "Created Doc. Ref. No."; Integer)
        {
            Caption = 'Created Doc. Ref. No.';
            Editable = false;
        }
        field(17; "Created By User ID"; Code[50])
        {
            Caption = 'Created By User ID';
            Editable = false;
        }
        field(18; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
        field(19; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
        }
        field(20; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
        }
        field(21; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;

            trigger OnValidate()
            begin
                Validate(Billable, "Job No." <> '');
                if "Job No." = '' then
                    Validate("Job Task No.", '');

                AddDefaultDim(CurrFieldNo);
            end;
        }
        field(22; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));

            trigger OnValidate()
            begin
                Validate(Billable, "Job Task No." <> '');
                AddDefaultDim(CurrFieldNo);
            end;
        }
        field(23; Billable; Boolean)
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
        field(24; "Job Line Type"; Option)
        {
            Caption = 'Job Line Type';
            Editable = false;
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
        field(25; "Reimbursement Register No."; Integer)
        {
            Caption = 'Reimbursement Register No.';
            TableRelation = "CEM Register";
        }
        field(26; "Reimbursement Method"; Option)
        {
            Caption = 'Reimbursement Method';
            OptionCaption = 'Internal (on User),External Payroll System,Both';
            OptionMembers = "Vendor (on User)","External System",Both;
        }
        field(27; Reimbursed; Boolean)
        {
            Caption = 'Reimbursed';
        }
        field(28; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(29; Comment; Boolean)
        {
            CalcFormula = exist("CEM Comment" where("Table ID" = const(6086387),
                                                     "Document Type" = const(Budget),
                                                     "Document No." = const(''),
                                                     "Doc. Ref. No." = field("Entry No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Entry No. (Code)"; Code[20])
        {
            Caption = 'Entry No. (Code)';
        }
        field(31; "Per Diem GUID"; Guid)
        {
            Caption = 'Per Diem GUID';
        }
        field(32; "Register No."; Integer)
        {
            Caption = 'Register No.';
            TableRelation = "CEM Register";
        }
        field(33; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(34; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(39; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending Expense User,Pending Approval,Released';
            OptionMembers = Open,"Pending Expense User","Pending Approval",Released;
        }
        field(40; "Current Reminder Level"; Integer)
        {
            CalcFormula = max("CEM Reminder"."No." where("Table ID" = const(6086387),
                                                          "Document Type" = const(Budget),
                                                          "Document No." = const(''),
                                                          "Doc. Ref. No." = field("Entry No.")));
            Caption = 'Current Reminder Level';
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "Settlement No."; Code[20])
        {
            Caption = 'Settlement No.';
            TableRelation = "CEM Expense Header"."No." where("Document Type" = const(Settlement),
                                                              "Continia User ID" = field("Continia User ID"));

        }
        field(42; "Settlement Line No."; Integer)
        {
            Caption = 'Settlement Line No.';
        }
        field(43; "Per Diem Group Code"; Code[20])
        {
            Caption = 'Per Diem Group Code';
            TableRelation = "CEM Per Diem Group";
        }
        field(44; "Response from Dataloen"; Text[100])
        {
            Caption = 'Response from Dataloen';
        }
        field(45; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
        }
        field(46; "Posted Date/Time"; DateTime)
        {
            Caption = 'Posted Date Time';
            Editable = false;
        }
        field(47; "Posted by User ID"; Code[50])
        {
            Caption = 'Posted by User ID';
            Editable = false;
        }
        field(48; "Per Diem Completed"; Boolean)
        {
            Caption = 'Per Diem Completed';
        }
        field(49; "Continia Online Version No."; Text[100])
        {
            Caption = 'Continia Online Version No.';
        }
        field(50; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(51; "Settlement GUID"; Guid)
        {
            Caption = 'Settlement GUID';
        }
        field(52; "Usage Entry No."; Integer)
        {
            Caption = 'Usage Entry No.';
            Editable = false;
        }
        field(53; "Updated By Delegation User"; Code[50])
        {
            Caption = 'Updated By Delegation User';
        }
        field(54; "Notification Type"; Option)
        {
            Caption = 'Notification Type';
            OptionMembers = " ","New document","Important update","New history status";
        }
        field(55; "Departure Country/Region"; Code[10])
        {
            Caption = 'Departure Country/Region';
        }
        field(65; "Employee Reimbursed"; Boolean)
        {
            Caption = 'Employee Reimbursed';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Status)
        {
        }
        key(Key3; "Continia User ID", "Posting Date", Posted, Reimbursed, "Per Diem Group Code")
        {
        }
        key(Key4; "Continia User ID", Reimbursed)
        {
        }
        key(Key5; "Continia User ID", Status, Posted, "Settlement No.")
        {
        }
        key(Key6; "Per Diem GUID")
        {
        }
        key(Key7; Posted)
        {
        }
        key(Key8; "Settlement No.", "Settlement Line No.")
        {
        }
        key(Key9; Posted, "Settlement No.")
        {
        }
        key(Key10; "Settlement No.", Posted, "Posted Date/Time", "Entry No.")
        {
        }
        key(Key11; Posted, "Continia User ID", Status)
        {
        }
        key(Key12; "Created Doc. Type", "Created Doc. Subtype", "Created Doc. ID", "Created Doc. Ref. No.")
        {
        }
        key(Key13; "Continia User ID", "Departure Date/Time")
        {
        }
    }
    procedure GetEntryNo(): Integer
    begin
    end;

    procedure CheckInboxAndThrowError()
    begin
    end;

    procedure ExistsInInbox(): Boolean
    begin
    end;

    procedure ThrowInboxError()
    begin
    end;

    procedure UpdateDetails()
    begin
    end;

    procedure GetNextDocumentLineNo() LineNo: Integer
    begin
    end;

    procedure HasPerDiemComment(): Boolean
    begin
    end;


    procedure HasErrorComment(ShowFirstError: Boolean; RunValidationChecks: Boolean): Boolean
    begin
    end;


    procedure HasWarningComment(ShowFirstError: Boolean): Boolean
    begin
    end;


    procedure HasApprovalComment(): Boolean
    var
        ApprovalCmtLine: Record "Approval Comment Line";
    begin
        ApprovalCmtLine.SetCurrentKey("Table ID", "Document Type", "Document No.");
        ApprovalCmtLine.SetRange("Table ID", DATABASE::"CEM Per Diem");
        ApprovalCmtLine.SetRange("Document Type", ApprovalCmtLine."Document Type"::Invoice);
        ApprovalCmtLine.SetRange("Document No.", Format("Entry No."));
        exit(not ApprovalCmtLine.IsEmpty);
    end;


    procedure SetSkipSendToExpUser(NewSkipSendToExpUser: Boolean)
    begin
    end;

    procedure CheckUnProcessedInbox()
    begin
    end;

    procedure AddDefaultDim(ValidatedFieldNo: Integer)
    begin
    end;

    procedure SendToExpenseUser()
    begin
    end;

    procedure GetReimbursMethodForRecUsr(): Integer
    var
        DefaultUserSetup: Record "CEM Default User Setup";
    begin
        exit(DefaultUserSetup.GetPerDReimbursMethodForUser("Continia User ID"));
    end;

    procedure SetSuspendInboxCheck(NewSuspend: Boolean)
    begin
    end;

    procedure GetOverviewDetails() AddInfo: Text[250]
    begin
    end;

    procedure GetDepartureDate(): Date
    begin
        exit(DT2Date("Departure Date/Time"));
    end;

    procedure LookupDimensions(Editable: Boolean)
    begin
    end;

    procedure LookupExtraFields(Editable: Boolean)
    begin
    end;

    procedure IsSyncRequired(): Boolean
    begin
    end;

    procedure AttachPerDiemToSettlement(var PerDiem: Record "CEM Per Diem")
    begin
    end;

    procedure DetachPerDiemFromSettlement(var PerDiem: Record "CEM Per Diem")
    begin
    end;

    procedure NextReminderDate(): Date
    var
        EMReminder: Record "CEM Reminder";
    begin
        exit(EMReminder.NextReminderDate("Continia User ID", DATABASE::"CEM Per Diem", 0, "Settlement No.", "Entry No.", GetEarliestDate()));
    end;


    procedure GetEarliestDate(): Date
    var
        DepartureDate: Date;
    begin
        //BETWEEN DOCUMENT DATE AND DATE CREATED
        DepartureDate := DT2Date("Departure Date/Time");

        if DepartureDate = 0D then
            exit("Date Created");

        if "Date Created" = 0D then
            exit(DepartureDate);

        if "Date Created" < DepartureDate then
            exit("Date Created")
        else
            exit(DepartureDate);
    end;


    procedure ShowReminders()
    begin
    end;

    procedure Navigate()
    begin
    end;

    procedure LookupPerDiemDetails()
    begin
    end;

    procedure ShowPerDiem()
    begin
    end;

    procedure FindPerDiemPostingGroup(PerDiemPostingGroupCode: Code[20]; DestinationCountryRegion: Code[20]; var PerDiemPostingGroup: Record "CEM Per Diem Posting Group")
    begin
    end;

    procedure GetPstSetupForAllowanceCode(PerDiem: Record "CEM Per Diem"; AllowanceCode: Code[20]; var PostingSetup: Record "CEM Posting Setup")
    begin
    end;

    procedure LookupComments()
    begin
    end;

    procedure ShowDetails()
    begin
    end;

    procedure OpenDocumentCard()
    begin
    end;

    procedure SplitAndAllocate()
    begin
    end;

    procedure DrillDownAttendees()
    begin
    end;

    procedure ShowAttachments()
    begin
    end;

    procedure PostingSetupUsesExternalAccNo() ExternalAccountUsed: Boolean
    var
        PerDiemPostingGroup: Record "CEM Per Diem Posting Group";
        PostingSetup: Record "CEM Posting Setup";
        AllowanceCodes: array[5] of Code[20];
        i: Integer;
    begin
        if not PerDiemPostingGroup.Get("Per Diem Group Code", "Destination Country/Region") then
            exit(false);

        PerDiemPostingGroup.LoadAllowanceInArrayAndCheck(AllowanceCodes);

        ExternalAccountUsed := true;
        for i := 1 to ArrayLen(AllowanceCodes) do
            if AllowanceCodes[i] <> '' then begin
                PerDiemPostingGroup.GetAllowancePostingSetup("Continia User ID", AllowanceCodes[i], PostingSetup, false);
                ExternalAccountUsed := ExternalAccountUsed and (PostingSetup."External Posting Account No." <> '');
            end;
    end;


    procedure GetTableCaptionPlural(): Text[250]
    begin
    end;

    procedure GetRecordID(var RecID: RecordID)
    begin
    end;

    procedure FindOverlapingPerdiemEntryNo(var EntryNo: Integer): Boolean
    begin
        EntryNo := 0;
    end;

    procedure EmployeeReimbExpectedInBC(): Boolean
    begin
        exit("Reimbursement Method" = "Reimbursement Method"::"Vendor (on User)");
    end;


    procedure GetExternalDocNo(): Code[20]
    begin
    end;


    procedure GetDepartureCountryRegionTxt(): Text[1024]
    var
        CountryRegion: Record "CEM Country/Region";
    begin
        if CountryRegion.Get(Rec."Departure Country/Region") then
            exit(CountryRegion.Name);
    end;


    procedure ReopenPerDiems(var PerDiem: Record "CEM Per Diem")
    begin
    end;

    procedure StatusAllowsChange() Condition: Boolean
    begin
        Condition := Status in [Status::Open, Status::"Pending Expense User"];
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

    procedure ShouldHandleCASalesTax(): Boolean
    begin
    end;

    procedure NextApprover(): Code[50]
    begin
    end;

    procedure CurrentUserIsNextApprover(): Boolean
    begin
    end;
}