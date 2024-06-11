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
            TableRelation = "CDC Continia User Setup";

            trigger OnValidate()
            var
                UserDelegation: Record "CEM User Delegation";
                EmptyGuid: Guid;
            begin
                if "Settlement No." <> '' then
                    Error(CannotChangeWhenSttl, FieldCaption("Continia User ID"));

                if "Continia User ID" = xRec."Continia User ID" then
                    exit;

                Validate("Reimbursement Method", GetReimbursMethodForRecUsr);

                UserDelegation.VerifyUser("Continia User ID");

                TestField(Status, Status::Open);

                if xRec."Continia User ID" <> "Continia User ID" then begin
                    CheckInboxAndThrowError;

                    if "Per Diem GUID" <> EmptyGuid then
                        "Per Diem GUID" := EmptyGuid;
                end;

                Validate("Per Diem Group Code");
                SetDefaultPostingSetup;

                CalcFields("Continia User Name");

                AddDefaultDim(CurrFieldNo);
            end;
        }
        field(3; "Continia User Name"; Text[50])
        {
            CalcFormula = Lookup("CDC Continia User".Name WHERE("User ID" = FIELD("Continia User ID")));
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

            trigger OnValidate()
            begin
                TestStatusAllowsChange;
                "Departure Date/Time" := RoundDateTime("Departure Date/Time", 60000L);
                ValidateDates;
                PerDiemValidate.Run(Rec);
            end;
        }
        field(7; "Return Date/Time"; DateTime)
        {
            Caption = 'Return Date/Time';

            trigger OnValidate()
            begin
                TestStatusAllowsChange;
                "Return Date/Time" := RoundDateTime("Return Date/Time", 60000L);
                ValidateDates;
                "Posting Date" := DT2Date("Return Date/Time");

                PerDiemValidate.Run(Rec);
            end;
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
                TestStatusAllowsChange;
                Validate("Per Diem Group Code");
            end;
        }
        field(10; "Currency Code"; Code[10])
        {
            CalcFormula = Lookup("CEM Per Diem Detail"."Currency Code" WHERE("Per Diem Entry No." = FIELD("Entry No.")));
            Caption = 'Currency Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Currency;
        }
        field(11; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("CEM Per Diem Detail".Amount WHERE("Per Diem Entry No." = FIELD("Entry No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("CEM Per Diem Detail"."Amount (LCY)" WHERE("Per Diem Entry No." = FIELD("Entry No.")));
            Caption = 'Amount (LCY)';
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
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            var
                EMDimMgt: Codeunit "CEM Dimension Mgt.";
            begin
                EMDimMgt.UpdateEMDimForGlobalDim(DATABASE::"CEM Per Diem", 0, '', "Entry No.", 1, "Global Dimension 1 Code");
            end;
        }
        field(20; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            var
                EMDimMgt: Codeunit "CEM Dimension Mgt.";
            begin
                EMDimMgt.UpdateEMDimForGlobalDim(DATABASE::"CEM Per Diem", 0, '', "Entry No.", 2, "Global Dimension 2 Code");
            end;
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
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

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
            CalcFormula = Exist("CEM Comment" WHERE("Table ID" = CONST(6086387),
                                                     "Document Type" = CONST(Budget),
                                                     "Document No." = CONST(''),
                                                     "Doc. Ref. No." = FIELD("Entry No.")));
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
            CalcFormula = Max("CEM Reminder"."No." WHERE("Table ID" = CONST(6086387),
                                                          "Document Type" = CONST(Budget),
                                                          "Document No." = CONST(''),
                                                          "Doc. Ref. No." = FIELD("Entry No.")));
            Caption = 'Current Reminder Level';
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "Settlement No."; Code[20])
        {
            Caption = 'Settlement No.';
            TableRelation = "CEM Expense Header"."No." WHERE("Document Type" = CONST(Settlement),
                                                              "Continia User ID" = FIELD("Continia User ID"));

            trigger OnLookup()
            var
                Settlement: Record "CEM Expense Header";
            begin
                if "Settlement No." <> '' then
                    if Settlement.Get(Settlement."Document Type"::Settlement, "Settlement No.") then;
                if "Continia User ID" <> '' then
                    Settlement.SetRange("Continia User ID", "Continia User ID");
                if Posted then
                    PAGE.RunModal(PAGE::"CEM Posted Settlement List", Settlement)
                else
                    if PAGE.RunModal(PAGE::"CEM Settlement List", Settlement) = ACTION::LookupOK then
                        Validate("Settlement No.", Settlement."No.");
            end;

            trigger OnValidate()
            begin
                if "Settlement No." = xRec."Settlement No." then
                    exit;

                TestStatusAllowsChange;

                if _ExpHeader.Get(_ExpHeader."Document Type"::Settlement, "Settlement No.") then begin
                    _ExpHeader.TestField("Continia User ID", "Continia User ID");
                    _ExpHeader.TestField(Posted, false);
                    if _ExpHeader.Status = _ExpHeader.Status::Released then
                        Error(SettlementReleasedTxt);

                    if "Settlement Line No." = 0 then
                        "Settlement Line No." := GetNextDocumentLineNo;
                    "Settlement GUID" := _ExpHeader."Exp. Header GUID";
                    if "Departure Date/Time" = 0DT then
                        "Departure Date/Time" := _ExpHeader."Departure Date/Time";
                    if "Return Date/Time" = 0DT then
                        "Return Date/Time" := _ExpHeader."Return Date/Time";
                end else begin
                    "Settlement Line No." := 0;
                    Clear("Settlement GUID");
                end;
            end;
        }
        field(42; "Settlement Line No."; Integer)
        {
            Caption = 'Settlement Line No.';
        }
        field(43; "Per Diem Group Code"; Code[20])
        {
            Caption = 'Per Diem Group Code';
            TableRelation = "CEM Per Diem Group";

            trigger OnValidate()
            var
                BankTransaction: Record "CEM Bank Transaction";
                EMSetup: Record "CEM Expense Management Setup";
                ExpenseType: Record "CEM Expense Type";
                ExpPostingSetup: Record "CEM Posting Setup";
            begin
                AddDefaultDim(CurrFieldNo);

                if Description = '' then
                    Description := ExpenseType.Description;

                SetDefaultPostingSetup;
            end;
        }
        field(44; "Response from Dataloen"; Text[100])
        {
            Caption = 'Response from Dataloen';
        }
        field(45; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;

            trigger OnValidate()
            begin
                "Posted Date/Time" := CurrentDateTime;
                "Posted by User ID" := UserId;
            end;
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
            TableRelation = "CDC Continia User Setup";

            trigger OnValidate()
            var
                EMComment: Record "CEM Comment";
                CmtMgt: Codeunit "CEM Comment Mgt.";
            begin
                if ("Updated By Delegation User" <> '') and (Rec."Updated By Delegation User" <> "Updated By Delegation User") then
                    CmtMgt.AddComment(DATABASE::"CEM Per Diem", 0, '', "Entry No.", EMComment.Importance::Information, 'DELEGATIONUPDATED',
                      StrSubstNo(DelegateUpdateTxt, "Continia User ID"), false);
            end;
        }
        field(54; "Notification Type"; Option)
        {
            Caption = 'Notification Type';
            OptionMembers = " ","New document","Important update","New history status";
        }
        field(55; "Departure Country/Region"; Code[10])
        {
            Caption = 'Departure Country/Region';
            TableRelation = "CEM Country/Region";

            trigger OnValidate()
            begin
                TestStatusAllowsChange;
                Validate("Per Diem Group Code");
            end;
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

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        EMComment: Record "CEM Comment";
        EMDimension: Record "CEM Dimension";
        PerDiemDetail: Record "CEM Per Diem Detail";
        EMReminder: Record "CEM Reminder";
        EMApprovalsBridge: Codeunit "CEM Approvals Bridge";
        EMOnlineMgt: Codeunit "CEM Online Synch. Mgt.";
    begin
        TestField(Posted, false);
        TestStatusAllowsChange;
        CheckInboxAndThrowError;

        PerDiemDetail.LockTable;
        PerDiemDetail.SetRange("Per Diem Entry No.", "Entry No.");
        PerDiemDetail.SetSkipSendToUser(true);
        if PerDiemDetail.FindSet(true, true) then
            repeat
                PerDiemDetail.Delete(true);
            until PerDiemDetail.Next = 0;

        EMDimension.LockTable;
        EMDimension.SetCurrentKey("Table ID", "Document Type", "Document No.", "Doc. Ref. No.");
        EMDimension.SetRange("Table ID", DATABASE::"CEM Per Diem");
        EMDimension.SetRange("Document Type", 0);
        EMDimension.SetRange("Document No.", '');
        EMDimension.SetRange("Doc. Ref. No.", "Entry No.");
        EMDimension.DeleteAll;

        EMReminder.SetCurrentKey("Table ID", "Document Type", "Document No.", "Doc. Ref. No.");
        EMReminder.SetRange("Table ID", DATABASE::"CEM Per Diem");
        EMReminder.SetRange("Document Type", 0);
        EMReminder.SetRange("Document No.", '');
        EMReminder.SetRange("Doc. Ref. No.", "Entry No.");
        EMReminder.DeleteAll(true);

        if Status = Status::"Pending Expense User" then
            EMOnlineMgt.PhysicalDeleteDocFromCO(DATABASE::"CEM Per Diem", "Per Diem GUID", true);

        EMComment.SetCurrentKey("Table ID", "Document Type", "Document No.", "Doc. Ref. No.");
        EMComment.SetRange("Table ID", DATABASE::"CEM Per Diem");
        EMComment.SetRange("Document Type", 0);
        EMComment.SetRange("Document No.", '');
        EMComment.SetRange("Doc. Ref. No.", "Entry No.");
        EMComment.DeleteAll(true);

        EMApprovalsBridge.DeleteApprovalEntries(DATABASE::"CEM Per Diem", Format("Entry No."));
    end;

    trigger OnInsert()
    var
        EMSetup: Record "CEM Expense Management Setup";
        PerDiemGroup: Record "CEM Per Diem Group";
        CEMModuleLicense: Codeunit "CEM Module License";
        SendToExpUser: Codeunit "CEM Per Diem - Send to User";
    begin
        CEMModuleLicense.PerDiemModuleActivated(true);
        TestField(Posted, false);
        EMSetup.Get;
        EMSetup.TestField("Enable Per Diem", true);

        "Entry No." := GetEntryNo;
        "Entry No. (Code)" := Format("Entry No.");

        if "Continia User ID" = '' then
            "Continia User ID" := UserId;
        if "Departure Date/Time" = 0DT then
            "Departure Date/Time" := RoundDateTime(CurrentDateTime, 3600000L, '<');
        if "Return Date/Time" = 0DT then
            "Return Date/Time" := RoundDateTime(CurrentDateTime, 3600000L, '>');
        "Posting Date" := Today;

        Validate("Reimbursement Method", GetReimbursMethodForRecUsr);

        CheckDates;

        if "Per Diem Group Code" = '' then
            Validate("Per Diem Group Code", PerDiemGroup.GetDefaultPerDiemGroupCode("Continia User ID"));

        SetDefaultPostingSetup;

        if ("Entry No." > 0) and ("Settlement No." <> '') and ("Settlement Line No." = 0) then
            "Settlement Line No." := GetNextDocumentLineNo;

        if "Settlement No." <> '' then begin
            _ExpHeader.Get(_ExpHeader."Document Type"::Settlement, "Settlement No.");
            _ExpHeader.TestStatusAllowsChange;

            if Status <> _ExpHeader.Status then begin
                if _ExpHeader.Status = _ExpHeader.Status::"Pending Expense User" then
                    SendToExpUser.UpdateRef(Rec);
                Status := _ExpHeader.Status;
            end;
            Validate("Global Dimension 1 Code", "Global Dimension 1 Code");
            Validate("Global Dimension 2 Code", "Global Dimension 2 Code");
        end;

        // Send notification in the app
        "Notification Type" := "Notification Type"::"New document";
        TestStatusAllowsChange;

        AddDefaultDim(0);
        UpdateDetails;

        PerDiemValidate.Run(Rec);

        "Date Created" := Today;
        "Created By User ID" := UserId;
    end;

    trigger OnModify()
    var
        UsageImplementation: Codeunit "CEM Usage Implementation";
        Sent: Boolean;
    begin
        TestField(Posted, false);
        TestStatusOrUserAllowsChange;

        CheckDates;

        if "Settlement No." <> '' then begin
            _ExpHeader.Get(_ExpHeader."Document Type"::Settlement, "Settlement No.");
            if Status <> _ExpHeader.Status then begin
                TestField(Status, Status::Open);
                if _ExpHeader.Status = _ExpHeader.Status::"Pending Expense User" then begin
                    CODEUNIT.Run(CODEUNIT::"CEM Per Diem - Send to User", Rec);
                    Sent := true;
                end;

                Status := _ExpHeader.Status;
            end;
        end;

        "Entry No. (Code)" := Format("Entry No.");
        UpdateDetails;
        if not Sent then
            SendToExpenseUser;

        PerDiemValidate.Run(Rec);

        UsageImplementation.LogPerDiemUsageIfValid(Rec);
    end;

    var
        _ExpHeader: Record "CEM Expense Header";
        PerDiemValidate: Codeunit "CEM Per Diem-Validate";
        SkipSendToExpUser: Boolean;
        SuspendInboxCheck: Boolean;
        AttachmentsNotAllowdErr: Label 'Attachments are not supported for %1.';
        CannotChangeWhenSttl: Label '%1 cannot be changed when assigned to a settlement.';
        ConfirmDetachPerDiemMultiple: Label 'Do you want to detach %1 per diems from this settlement?';
        ConfirmDetachPerDiemSingle: Label 'Do you want to detach the per diem from this settlement?';
        DateErr: Label '%1 cannot be later than %2.';
        DelegateUpdateTxt: Label 'Updated by delegated user %1.';
        DrillDownNotAllowdErr: Label 'Drill Down on attendees is not supported for %1.';
        EMInboxFoundErr: Label '%1 %2 cannot be updated as there are one or more unprocessed lines in the %3.\\Please process the related lines in the %3 before making changes to this %1.';
        MaxNoOfDaysError: Label 'Maximum number of days reached. The interval between the start and end date cannot be longer than 180 days. Please create a new per diem.';
        NoPerDiemInSelection: Label 'Please select one or more per diems to detach.';
        OneOrMoreInboxError: Label 'There are one or more unprocessed entries in the %1.';
        PerDiemsPlural: Label 'Per diems';
        ProcessInboxAsapTxt: Label 'You should process these as soon as possible.';
        PurchasePostingNotAllowed: Label '%1 %2 cannot be %3, when %4 with %5 exists.';
        ReopenMultiplePendExpUsrQst: Label 'This will reopen %1 per diems.\Reopening a document can discard user''s changes when the Mobile App doesn''t have internet connection.\\Are you sure you want to continue?';
        ReopenMultipleQst: Label 'This will reopen %1 per diems.\Are you sure you want to continue?';
        ReopenSinglePendExpUsrQst: Label 'Reopening a document can discard user''s changes when the Mobile App doesn''t have internet connection.\\Are you sure you want to continue?';
        ReopenSingleQst: Label 'This will reopen this per diem.\Are you sure you want to continue?';
        SettlementReleasedTxt: Label 'The settlement must not be released.';
        SplitNotAllowdErr: Label 'Split and allocate is not supported for %1.';
        StatusNotAllowed: Label 'Status must be Open or Pending Expense User in %1 %2.';


    procedure GetEntryNo(): Integer
    var
        PerDiem: Record "CEM Per Diem";
    begin
        if PerDiem.FindLast then
            exit(PerDiem."Entry No." + 1)
        else
            exit(1);
    end;


    procedure CheckInboxAndThrowError()
    begin
        if not SuspendInboxCheck then
            if ExistsInInbox then
                ThrowInboxError;
    end;


    procedure ExistsInInbox(): Boolean
    var
        PerDiemInbox: Record "CEM Per Diem Inbox";
    begin
        PerDiemInbox.SetCurrentKey("Per Diem GUID");
        PerDiemInbox.SetRange("Per Diem GUID", "Per Diem GUID");
        PerDiemInbox.SetFilter(Status, '%1|%2', PerDiemInbox.Status::Pending, PerDiemInbox.Status::Error);
        if not PerDiemInbox.IsEmpty then
            exit(true);
    end;


    procedure ThrowInboxError()
    var
        PerDiemInbox: Record "CEM Per Diem Inbox";
    begin
        Error(EMInboxFoundErr, TableCaption, "Entry No.", PerDiemInbox.TableCaption);
    end;

    local procedure CheckDates()
    var
        PerDiemCalcEngine: Codeunit "CEM Per Diem Calc. Engine";
    begin
        if ("Return Date/Time" <> 0DT) and ("Departure Date/Time" > "Return Date/Time") then
            Error(DateErr, FieldCaption("Departure Date/Time"), FieldCaption("Return Date/Time"));

        if ("Departure Date/Time" <> 0DT) and ("Return Date/Time" <> 0DT) then
            if (PerDiemCalcEngine.ConvertMsToDays("Return Date/Time" - "Departure Date/Time") > 180) then
                Error(MaxNoOfDaysError); // 180 Days limit to prevent overload
    end;

    local procedure ValidateDates()
    var
        PerDiemCalcEngine: Codeunit "CEM Per Diem Calc. Engine";
    begin
        if ("Return Date/Time" = 0DT) then
            exit;

        if "Departure Date/Time" > "Return Date/Time" then begin
            Message(DateErr, FieldCaption("Departure Date/Time"), FieldCaption("Return Date/Time"));
            Validate("Return Date/Time", 0DT);
            exit;
        end;

        if (PerDiemCalcEngine.ConvertMsToDays("Return Date/Time" - "Departure Date/Time") > 180) then begin
            Message(MaxNoOfDaysError); // 180 Days limit to prevent overload
            Validate("Return Date/Time", 0DT);
        end;
    end;


    procedure UpdateDetails()
    var
        EMSetup: Record "CEM Expense Management Setup";
        PerDiemDetails: Record "CEM Per Diem Detail";
        PerDiemDetailsTemp: Record "CEM Per Diem Detail" temporary;
        PerDiemDetailDest: Record "CEM Per Diem Detail Dest.";
        PerDiemDetailDestTemp: Record "CEM Per Diem Detail Dest." temporary;
        PerDiemCalcEngine: Codeunit "CEM Per Diem Calc. Engine";
        FirstDay: Boolean;
        CurrentDate: Date;
    begin
        if ("Departure Date/Time" = 0DT) or ("Return Date/Time" = 0DT) then begin
            PerDiemDetails.SetRange("Per Diem Entry No.", "Entry No.");
            PerDiemDetails.DeleteAll(true);
            exit;
        end;

        PerDiemDetailsTemp.DeleteAll;
        PerDiemDetailDestTemp.DeleteAll;

        // Store previous user input in temp
        PerDiemDetails.SetCurrentKey("Per Diem Entry No.", Modified);
        PerDiemDetails.SetRange("Per Diem Entry No.", "Entry No.");
        PerDiemDetails.SetRange(Modified, true);
        if PerDiemDetails.FindSet then
            repeat
                PerDiemDetailsTemp.Copy(PerDiemDetails);
                PerDiemDetailsTemp.Insert;
            until PerDiemDetails.Next = 0;

        // Store Details that have Destinations
        PerDiemDetailDest.SetRange("Per Diem Entry No.", "Entry No.");
        if PerDiemDetailDest.FindSet then
            repeat
                // Copy Destinations
                PerDiemDetailDestTemp.Copy(PerDiemDetailDest);
                PerDiemDetailDestTemp.Insert;

                // Copy Details
                Clear(PerDiemDetails);
                PerDiemDetails.SetRange("Per Diem Entry No.", PerDiemDetailDest."Per Diem Entry No.");
                PerDiemDetails.SetRange("Entry No.", PerDiemDetailDest."Per Diem Detail Entry No.");
                PerDiemDetails.FindFirst;

                PerDiemDetailsTemp.Copy(PerDiemDetails);
                if not PerDiemDetailsTemp.Insert then; // Duplicates are expected.
            until PerDiemDetailDest.Next = 0;


        // Delete the (already copied) Details
        Clear(PerDiemDetails);
        PerDiemDetails.SetRange("Per Diem Entry No.", "Entry No.");
        if PerDiemDetails.FindSet then
            repeat
                PerDiemDetails.SetSkipSendToUser(true);
                PerDiemDetails.Delete(true);
            until PerDiemDetails.Next = 0;

        FirstDay := true;

        // Generate default entries
        for CurrentDate := DT2Date("Departure Date/Time") to DT2Date("Return Date/Time") do begin
            Clear(PerDiemDetails);
            PerDiemDetails."Per Diem Entry No." := "Entry No.";
            PerDiemDetails.Date := CurrentDate;
            PerDiemDetails."Admin Comment" := "Admin Comment";
            PerDiemDetails.Description := Description;
            EMSetup.Get;
            if EMSetup."Allowances given by default" then begin
                if not FirstDay then
                    PerDiemDetails."Accommodation Allowance" := true;

                PerDiemDetails.Breakfast := true;
                PerDiemDetails.Lunch := true;
                PerDiemDetails.Dinner := true;

                if EMSetup."Use Drinks Allowance" then
                    PerDiemDetails."Drinks Allowance" := true;

                if EMSetup."Use Transport Allowance" then
                    PerDiemDetails."Transport Allowance" := true;

                if EMSetup."Use Entertainment Allowance" then
                    PerDiemDetails."Entertainment Allowance" := true;
            end;
            PerDiemDetails.Insert(true);

            FirstDay := false
        end;

        // Restore user input
        Clear(PerDiemDetailsTemp);
        if PerDiemDetailsTemp.FindSet then
            repeat
                Clear(PerDiemDetails);
                PerDiemDetails.SetCurrentKey("Per Diem Entry No.", Date);
                PerDiemDetails.SetRange("Per Diem Entry No.", PerDiemDetailsTemp."Per Diem Entry No.");
                PerDiemDetails.SetRange(Date, PerDiemDetailsTemp.Date);
                if PerDiemDetails.FindFirst then begin
                    PerDiemDetails.Description := PerDiemDetailsTemp.Description;
                    PerDiemDetails."Description 2" := PerDiemDetailsTemp."Description 2";
                    PerDiemDetails."Admin Comment" := PerDiemDetailsTemp."Admin Comment";
                    PerDiemDetails."Accommodation Allowance" := PerDiemDetailsTemp."Accommodation Allowance";
                    PerDiemDetails.Breakfast := PerDiemDetailsTemp.Breakfast;
                    PerDiemDetails.Lunch := PerDiemDetailsTemp.Lunch;
                    PerDiemDetails.Dinner := PerDiemDetailsTemp.Dinner;
                    PerDiemDetails."Drinks Allowance" := PerDiemDetailsTemp."Drinks Allowance";
                    PerDiemDetails."Transport Allowance" := PerDiemDetailsTemp."Transport Allowance";
                    PerDiemDetails."Entertainment Allowance" := PerDiemDetailsTemp."Entertainment Allowance";
                    PerDiemDetails.Modified := true;
                    PerDiemDetails.Modify;

                    Clear(PerDiemDetailDestTemp);
                    PerDiemDetailDestTemp.SetRange("Per Diem Entry No.", PerDiemDetailsTemp."Per Diem Entry No.");
                    PerDiemDetailDestTemp.SetRange("Per Diem Detail Entry No.", PerDiemDetailsTemp."Entry No.");
                    if PerDiemDetailDestTemp.FindSet then
                        repeat
                            PerDiemDetailDest.Copy(PerDiemDetailDestTemp);
                            PerDiemDetailDest."Per Diem Detail Entry No." := PerDiemDetails."Entry No.";
                            PerDiemDetailDest."Entry No." := PerDiemDetailDestTemp."Entry No.";
                            PerDiemDetailDest.Insert;
                        until PerDiemDetailDestTemp.Next = 0;
                end;
            until PerDiemDetailsTemp.Next = 0;

        PerDiemCalcEngine.FindRateAndUpdAmtOnPerDiem(Rec);
        CalcFields(Amount, "Amount (LCY)");
    end;


    procedure GetNextDocumentLineNo() LineNo: Integer
    var
        Expense: Record "CEM Expense";
    begin
        Expense.SetCurrentKey("Settlement No.");
        Expense.SetRange("Settlement No.", "Settlement No.");
        Expense.SetFilter("Entry No.", '<>%1', "Entry No.");
        if Expense.FindLast then
            exit(Expense."Settlement Line No." + 10000);

        exit(10000);
    end;


    procedure HasPerDiemComment(): Boolean
    begin
        CalcFields(Comment);
        exit(Comment);
    end;


    procedure HasErrorComment(ShowFirstError: Boolean; RunValidationChecks: Boolean): Boolean
    var
        EMCmtMgt: Codeunit "CEM Comment Mgt.";
    begin
        exit(EMCmtMgt.HasErrorComments(DATABASE::"CEM Per Diem", 0, "Settlement No.", "Entry No.", ShowFirstError, RunValidationChecks));
    end;


    procedure HasWarningComment(ShowFirstError: Boolean): Boolean
    var
        EMCmtMgt: Codeunit "CEM Comment Mgt.";
    begin
        exit(EMCmtMgt.HasWarningComments(DATABASE::"CEM Per Diem", 0, "Settlement No.", "Entry No.", ShowFirstError, true));
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
        SkipSendToExpUser := NewSkipSendToExpUser;
    end;


    procedure CheckUnProcessedInbox()
    var
        PerDiemInbox: Record "CEM Per Diem Inbox";
        ReleaseNotificationEntry: Record "CEM Release Notification Entry";
        UserDelegation: Record "CEM User Delegation";
        NAVversionMgt: Codeunit "CEM NAV-version Mgt.";
        TextMessage: Text[1024];
    begin
        if UserDelegation.GetDelegationFilter <> '' then
            exit;

        PerDiemInbox.SetFilter(Status, '<>%1', PerDiemInbox.Status::Accepted);
        if not PerDiemInbox.IsEmpty then
            TextMessage := StrSubstNo(OneOrMoreInboxError, PerDiemInbox.TableCaption);

        if ReleaseNotificationEntry.CheckForUnprocessedEntries then begin
            if TextMessage <> '' then
                TextMessage := TextMessage + '\\';
            TextMessage := TextMessage + StrSubstNo(OneOrMoreInboxError, ReleaseNotificationEntry.TableCaption);
        end;

        if ReleaseNotificationEntry.CheckForUnprocessedHistEntries then
            NAVversionMgt.SendHistoryToCO(false);

        if TextMessage <> '' then
            Message(TextMessage + '\\' + ProcessInboxAsapTxt);
    end;


    procedure AddDefaultDim(ValidatedFieldNo: Integer)
    var
        ContiniaUser: Record "CDC Continia User Setup";
        EMDimMgt: Codeunit "CEM Dimension Mgt.";
    begin
        if "Entry No." = 0 then
            exit;

        DeleteOldDefaultDim;

        if ContiniaUser.Get("Continia User ID") then begin
            if ContiniaUser.GetSalesPurchCode <> '' then
                EMDimMgt.InsertDefaultDimPerDiem(DATABASE::"Salesperson/Purchaser", ContiniaUser.GetSalesPurchCode, Rec);

            if ContiniaUser."Vendor No." <> '' then
                EMDimMgt.InsertDefaultDimPerDiem(DATABASE::Vendor, ContiniaUser."Vendor No.", Rec);

            if ContiniaUser."Employee No." <> '' then;
            EMDimMgt.InsertDefaultDimPerDiem(DATABASE::Employee, ContiniaUser."Employee No.", Rec);
        end;

        if "Job No." <> '' then
            EMDimMgt.InsertDefaultDimPerDiem(DATABASE::Job, "Job No.", Rec);

        if "Job Task No." <> '' then
            EMDimMgt.InsertDefaultDimPerDiem(DATABASE::"Job Task", "Job Task No.", Rec);

        case ValidatedFieldNo of
            FieldNo("Continia User ID"):
                if ContiniaUser.Get("Continia User ID") then begin
                    if ContiniaUser.GetSalesPurchCode <> '' then
                        EMDimMgt.InsertDefaultDimPerDiem(DATABASE::"Salesperson/Purchaser", ContiniaUser.GetSalesPurchCode, Rec);

                    if ContiniaUser."Vendor No." <> '' then
                        EMDimMgt.InsertDefaultDimPerDiem(DATABASE::Vendor, ContiniaUser."Vendor No.", Rec);

                    if ContiniaUser."Employee No." <> '' then;
                    EMDimMgt.InsertDefaultDimPerDiem(DATABASE::Employee, ContiniaUser."Employee No.", Rec);
                end;

            FieldNo("Job No."):
                if "Job No." <> '' then
                    EMDimMgt.InsertDefaultDimPerDiem(DATABASE::Job, "Job No.", Rec);

            FieldNo("Job Task No."):
                if "Job Task No." <> '' then
                    EMDimMgt.InsertDefaultDimPerDiem(DATABASE::"Job Task", "Job Task No.", Rec);
        end;
    end;

    local procedure DeleteOldDefaultDim()
    var
        ContiniaUser: Record "CDC Continia User Setup";
        EMDimMgt: Codeunit "CEM Dimension Mgt.";
    begin
        if ContiniaUser.Get(xRec."Continia User ID") then begin
            if ContiniaUser.GetSalesPurchCode <> '' then
                EMDimMgt.DeleteDefaultDimPerDiem(DATABASE::"Salesperson/Purchaser", ContiniaUser.GetSalesPurchCode, Rec);

            if ContiniaUser."Vendor No." <> '' then
                EMDimMgt.DeleteDefaultDimPerDiem(DATABASE::Vendor, ContiniaUser."Vendor No.", Rec);

            if ContiniaUser."Employee No." <> '' then;
            EMDimMgt.DeleteDefaultDimPerDiem(DATABASE::Employee, ContiniaUser."Employee No.", Rec);
        end;

        if xRec."Job No." <> '' then
            EMDimMgt.DeleteDefaultDimPerDiem(DATABASE::Job, xRec."Job No.", Rec);

        if xRec."Job Task No." <> '' then
            EMDimMgt.DeleteDefaultDimPerDiem(DATABASE::"Job Task", xRec."Job Task No.", Rec);
    end;


    procedure SendToExpenseUser()
    var
        SendToExpUser: Codeunit "CEM Per Diem - Send to User";
    begin
        if SkipSendToExpUser then
            exit;

        if Status = Status::"Pending Expense User" then
            SendToExpUser.Update(Rec);
    end;


    procedure GetReimbursMethodForRecUsr(): Integer
    var
        DefaultUserSetup: Record "CEM Default User Setup";
    begin
        exit(DefaultUserSetup.GetPerDReimbursMethodForUser("Continia User ID"));
    end;


    procedure SetSuspendInboxCheck(NewSuspend: Boolean)
    begin
        SuspendInboxCheck := NewSuspend;
    end;


    procedure GetOverviewDetails() AddInfo: Text[250]
    var
        CountryRegion: Record "CEM Country/Region";
        PerDiemDetail: Record "CEM Per Diem Detail";
        NoOfBreakfast: Integer;
        NoOfDinner: Integer;
        NoOfLunch: Integer;
    begin
        if CountryRegion.Get("Destination Country/Region") then
            AddTextTo(AddInfo, CountryRegion.Name);

        PerDiemDetail.SetRange("Per Diem Entry No.", "Entry No.");
        if PerDiemDetail.FindSet then begin
            repeat
                if PerDiemDetail.Breakfast then
                    NoOfBreakfast := NoOfBreakfast + 1;
                if PerDiemDetail.Lunch then
                    NoOfLunch := NoOfLunch + 1;
                if PerDiemDetail.Dinner then
                    NoOfDinner := NoOfDinner + 1;
            until PerDiemDetail.Next = 0;

            AddTextTo(AddInfo, StrSubstNo('(%1:%2', PerDiemDetail.FieldCaption(Breakfast), NoOfBreakfast));
            AddTextTo(AddInfo, StrSubstNo('%1:%2', PerDiemDetail.FieldCaption(Lunch), NoOfLunch));
            AddTextTo(AddInfo, StrSubstNo('%1:%2)', PerDiemDetail.FieldCaption(Dinner), NoOfDinner));
        end;
    end;

    local procedure AddTextTo(var ReturnTxt: Text[250]; TxtToAdd: Text[250])
    begin
        if TxtToAdd = '' then
            exit;

        if (StrLen(TxtToAdd) + StrLen(ReturnTxt)) > MaxStrLen(ReturnTxt) then
            exit;

        if ReturnTxt = '' then
            ReturnTxt := TxtToAdd
        else
            ReturnTxt := ReturnTxt + ',' + TxtToAdd;
    end;


    procedure GetDepartureDate(): Date
    begin
        exit(DT2Date("Departure Date/Time"));
    end;


    procedure LookupDimensions(Editable: Boolean)
    var
        PerDiem: Record "CEM Per Diem";
    begin
        if PerDiem.Get("Entry No.") then
            DrillDownDimensions(PAGE::"CEM Dimensions", Editable);
    end;


    procedure LookupExtraFields(Editable: Boolean)
    var
        PerDiem: Record "CEM Per Diem";
    begin
        if PerDiem.Get("Entry No.") then
            DrillDownDimensions(PAGE::"CEM Extra Fields", Editable);
    end;

    local procedure DrillDownDimensions(FormID: Integer; Editable: Boolean)
    var
        EMDim: Record "CEM Dimension";
        TempEMDim: Record "CEM Dimension" temporary;
        ExpDim: Page "CEM Dimensions";
        ExpExtraFields: Page "CEM Extra Fields";
    begin
        EMDim.SetRange("Table ID", DATABASE::"CEM Per Diem");
        EMDim.SetRange("Document Type", 0);
        EMDim.SetRange("Document No.", '');
        EMDim.SetRange("Doc. Ref. No.", "Entry No.");

        if (not Posted) and StatusOrUserAllowsChange and Editable then begin
            if EMDim.FindSet then
                repeat
                    TempEMDim := EMDim;
                    TempEMDim.Insert;
                until EMDim.Next = 0;

            TempEMDim.SetRange("Table ID", DATABASE::"CEM Per Diem");
            TempEMDim.SetRange("Document Type", 0);
            TempEMDim.SetRange("Document No.", '');
            TempEMDim.SetRange("Doc. Ref. No.", "Entry No.");
            PAGE.RunModal(FormID, TempEMDim);

            if EMDim.EMDimUpdated(TempEMDim, DATABASE::"CEM Per Diem", 0, '', "Entry No.") then begin
                EMDim.DeleteAll(true);

                if TempEMDim.FindSet then
                    repeat
                        EMDim := TempEMDim;
                        EMDim.Insert(true);
                    until TempEMDim.Next = 0;

                Get("Entry No.");
                SendToExpenseUser;

                CODEUNIT.Run(CODEUNIT::"CEM Per Diem-Validate", Rec);
            end;
        end else
            case FormID of
                PAGE::"CEM Dimensions":
                    begin
                        ExpDim.SetTableView(EMDim);
                        ExpDim.SetReadOnly;
                        ExpDim.RunModal;
                    end;

                PAGE::"CEM Extra Fields":
                    begin
                        ExpExtraFields.SetTableView(EMDim);
                        ExpExtraFields.SetReadOnly;
                        ExpExtraFields.RunModal;
                    end;
            end;
    end;


    procedure IsSyncRequired(): Boolean
    var
        EMOnlineMgt: Codeunit "CEM Online Synch. Mgt.";
    begin
    end;


    procedure AttachPerDiemToSettlement(var PerDiem: Record "CEM Per Diem")
    var
        PerDiem2: Record "CEM Per Diem";
    begin
        if PerDiem.Count = 0 then
            Error(NoPerDiemInSelection);

        PerDiem.FindFirst;

        _ExpHeader.FilterGroup(4);
        _ExpHeader.SetRange("Continia User ID", PerDiem."Continia User ID");
        _ExpHeader.SetFilter(Status, '%1|%2', _ExpHeader.Status::Open, _ExpHeader.Status::"Pending Expense User");
        _ExpHeader.FilterGroup(0);
        if PAGE.RunModal(PAGE::"CEM Settlement List", _ExpHeader) = ACTION::LookupOK then
            repeat
                PerDiem.TestStatusAllowsChange;
                PerDiem2.Get(PerDiem."Entry No.");
                PerDiem2.Validate("Settlement No.", _ExpHeader."No.");
                PerDiem2.Modify(true);
            until PerDiem.Next = 0;
    end;


    procedure DetachPerDiemFromSettlement(var PerDiem: Record "CEM Per Diem")
    var
        PerDiem2: Record "CEM Per Diem";
        ConfirmText: Text[1024];
    begin
        if PerDiem.Count = 0 then
            Error(NoPerDiemInSelection);

        if PerDiem.Count = 1 then
            ConfirmText := ConfirmDetachPerDiemSingle
        else
            ConfirmText := StrSubstNo(ConfirmDetachPerDiemMultiple, PerDiem.Count);

        if Confirm(ConfirmText) then
            if PerDiem.FindSet then
                repeat
                    PerDiem2.Get(PerDiem."Entry No.");
                    PerDiem2.Validate("Settlement No.", '');
                    PerDiem2.Modify(true);
                until PerDiem.Next = 0;
    end;


    procedure NextReminderDate(): Date
    var
        EMReminder: Record "CEM Reminder";
    begin
        exit(EMReminder.NextReminderDate("Continia User ID", DATABASE::"CEM Per Diem", 0, "Settlement No.", "Entry No.", GetEarliestDate));
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
    var
        Reminders: Page "CEM Reminders";
    begin
        Reminders.SetRecordFilter(DATABASE::"CEM Per Diem", 0, '', "Entry No.");
        Reminders.RunModal;
    end;


    procedure Navigate()
    var
        NavigatePerDiem: Codeunit "CEM Navigate Per Diem - Find";
    begin
        NavigatePerDiem.NavigatePerDiem(Rec);
    end;


    procedure LookupPerDiemDetails()
    var
        PerDiemDetails: Record "CEM Per Diem Detail";
        PerDiemDetailsPage: Page "CEM Per Diem Details";
    begin
        PerDiemDetails.SetRange("Per Diem Entry No.", "Entry No.");
        PerDiemDetailsPage.SetTableView(PerDiemDetails);
        PerDiemDetailsPage.SetRecord(PerDiemDetails);
        if Rec.Posted then
            PerDiemDetailsPage.Editable(false);

        PerDiemDetailsPage.RunModal;
    end;


    procedure ShowPerDiem()
    begin
        // Deprecated

        if _ExpHeader.Get(_ExpHeader."Document Type"::Settlement, Rec."Settlement No.") then
            if _ExpHeader.Posted then
                PAGE.RunModal(PAGE::"CEM Posted Settlement Card", _ExpHeader)
            else
                PAGE.RunModal(PAGE::"CEM Settlement Card", _ExpHeader)
        else
            if Posted then
                PAGE.RunModal(PAGE::"CEM Posted Per Diem Card", Rec)
            else
                PAGE.RunModal(PAGE::"CEM Per Diem Card", Rec);
    end;


    procedure FindPerDiemPostingGroup(PerDiemPostingGroupCode: Code[20]; DestinationCountryRegion: Code[20]; var PerDiemPostingGroup: Record "CEM Per Diem Posting Group")
    begin
        Clear(PerDiemPostingGroup);
        PerDiemPostingGroup.SetRange("Per Diem Group Code", PerDiemPostingGroupCode);
        PerDiemPostingGroup.SetRange("Destination Country/Region", DestinationCountryRegion);
        PerDiemPostingGroup.FindFirst;
    end;


    procedure GetPstSetupForAllowanceCode(PerDiem: Record "CEM Per Diem"; AllowanceCode: Code[20]; var PostingSetup: Record "CEM Posting Setup")
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        Clear(PostingSetup);
        if AllowanceCode = '' then
            exit;

        ContiniaUserSetup.Get(PerDiem."Continia User ID");
        PostingSetup.FindPostingSetup(DATABASE::"CEM Per Diem", AllowanceCode, PerDiem."Destination Country/Region",
          ContiniaUserSetup."Continia User ID", ContiniaUserSetup."Expense User Group", true)
    end;


    procedure LookupComments()
    var
        EMCmtMgt: Codeunit "CEM Comment Mgt.";
    begin
        EMCmtMgt.LookupComments(DATABASE::"CEM Per Diem", 0, '', "Entry No.");
    end;


    procedure ShowDetails()
    var
        PerDiemDetail: Record "CEM Per Diem Detail";
    begin
        PerDiemDetail.SetRange(PerDiemDetail."Per Diem Entry No.", "Entry No.");
        PAGE.Run(PAGE::"CEM Per Diem Details", PerDiemDetail);
    end;


    procedure OpenDocumentCard()
    var
        Settlement: Record "CEM Expense Header";
        PerDiemCard: Page "CEM Per Diem Card";
        PostedPerDiemCard: Page "CEM Posted Per Diem Card";
    begin
        if Settlement.Get(Settlement."Document Type"::Settlement, "Settlement No.") then
            Settlement.OpenDocumentCard
        else
            if Posted then begin
                PostedPerDiemCard.SetRecord(Rec);
                PostedPerDiemCard.LockToSpecificDocumentNo("Entry No.");
                PostedPerDiemCard.Run;
            end else begin
                PerDiemCard.SetRecord(Rec);
                PerDiemCard.LockToSpecificDocumentNo("Entry No.");
                PerDiemCard.Run;
            end;
    end;


    procedure SplitAndAllocate()
    begin
        Error(SplitNotAllowdErr, TableCaption);
    end;


    procedure DrillDownAttendees()
    begin
        Error(DrillDownNotAllowdErr, TableCaption);
    end;


    procedure ShowAttachments()
    begin
        Error(AttachmentsNotAllowdErr, TableCaption);
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
        exit(PerDiemsPlural);
    end;


    procedure GetRecordID(var RecID: RecordID)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        RecID := RecRef.RecordId;
        RecRef.Close;
    end;


    procedure FindOverlapingPerdiemEntryNo(var EntryNo: Integer): Boolean
    var
        PerDiem: Record "CEM Per Diem";
    begin
        PerDiem.Reset;
        PerDiem.SetCurrentKey("Continia User ID", "Departure Date/Time");
        PerDiem.SetRange("Continia User ID", "Continia User ID");
        PerDiem.SetFilter("Entry No.", '<>%1', "Entry No.");
        PerDiem.SetRange("Departure Date/Time", "Departure Date/Time", "Return Date/Time");
        if PerDiem.FindFirst then begin
            EntryNo := PerDiem."Entry No.";
            exit(true);
        end;

        PerDiem.SetRange("Departure Date/Time");
        PerDiem.SetRange("Return Date/Time", "Departure Date/Time", "Return Date/Time");
        if PerDiem.FindFirst then begin
            EntryNo := PerDiem."Entry No.";
            exit(true);
        end;

        PerDiem.SetFilter("Departure Date/Time", '<=%1', "Return Date/Time");
        PerDiem.SetFilter("Return Date/Time", '>=%1', "Return Date/Time");
        if PerDiem.FindFirst then begin
            EntryNo := PerDiem."Entry No.";
            exit(true);
        end;
    end;


    procedure EmployeeReimbExpectedInBC(): Boolean
    begin
        exit("Reimbursement Method" = "Reimbursement Method"::"Vendor (on User)");
    end;


    procedure GetExternalDocNo(): Code[20]
    begin
        exit(StrSubstNo('%1 %2', TableCaption, Format("Entry No.")));
    end;


    procedure GetDepartureCountryRegionTxt(): Text[1024]
    var
        CountryRegion: Record "CEM Country/Region";
    begin
        if CountryRegion.Get(Rec."Departure Country/Region") then
            exit(CountryRegion.Name);
    end;


    procedure ReopenPerDiems(var PerDiem: Record "CEM Per Diem")
    var
        PerDiem2: Record "CEM Per Diem";
        PendingExpUserFound: Boolean;
        Question: Text[1024];
    begin
        // Do we have pending expense user records?
        PerDiem.SetRange(Status, PerDiem.Status::"Pending Expense User");
        PendingExpUserFound := not PerDiem.IsEmpty;
        PerDiem.SetRange(Status);

        if PerDiem.Count = 1 then begin
            if PendingExpUserFound then
                Question := ReopenSinglePendExpUsrQst
            else
                Question := ReopenSingleQst;
        end else
            if PendingExpUserFound then
                Question := StrSubstNo(ReopenMultiplePendExpUsrQst, PerDiem.Count)
            else
                Question := StrSubstNo(ReopenMultipleQst, PerDiem.Count);

        if not Confirm(Question, true) then
            exit;

        if PerDiem.FindSet(true, false) then
            repeat
                PerDiem2 := PerDiem;
                CODEUNIT.Run(CODEUNIT::"CEM Per Diem - Complete", PerDiem2);
            until PerDiem.Next = 0;
    end;


    procedure StatusAllowsChange() Condition: Boolean
    begin
        Condition := Status in [Status::Open, Status::"Pending Expense User"];
    end;


    procedure StatusOrUserAllowsChange() Condition: Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        Condition := StatusAllowsChange or ContiniaUserSetup.CanEditApprovedDocuments(UserId);
    end;


    procedure TestStatusAllowsChange()
    begin
        if not StatusAllowsChange then
            Error(StatusNotAllowed, TableCaption, "Entry No.");
    end;


    procedure TestStatusOrUserAllowsChange()
    begin
        if not StatusOrUserAllowsChange then
            Error(StatusNotAllowed, TableCaption, "Entry No.");
    end;


    procedure ShouldHandleCASalesTax(): Boolean
    var
        SalesTaxInterface: Codeunit "CEM Sales Tax Interface";
    begin
        // Control fields visibility inside EM
        // In this way the users cannot add the irrelevant fields in other localizations
        exit(SalesTaxInterface.ShouldHandleCASalesTax);
    end;

    local procedure SetDefaultPostingSetup()
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        PerDiemPostingGroup: Record "CEM Per Diem Posting Group";
        PostingSetup: Record "CEM Posting Setup";
        AllowanceCodes: array[5] of Code[20];
        i: Integer;
    begin
        if not ContiniaUserSetup.Get("Continia User ID") then
            Clear(ContiniaUserSetup);

        if "Tax Group Code" <> '' then
            exit;

        // Just take a default Tax Group Code.
        if PerDiemPostingGroup.Get("Per Diem Group Code", Rec."Destination Country/Region") then begin
            if PerDiemPostingGroup.LoadAllowanceInArrayAndCheck(AllowanceCodes) then
                for i := 1 to ArrayLen(AllowanceCodes) do
                    if AllowanceCodes[i] <> '' then begin
                        PerDiemPostingGroup.GetAllowancePostingSetup("Continia User ID", AllowanceCodes[i], PostingSetup, true);
                        if PostingSetup."Tax Group Code" <> '' then
                            "Tax Group Code" := PostingSetup."Tax Group Code";
                    end;
        end;

        PerDiemValidate.Run(Rec);
    end;


    procedure NextApprover(): Code[50]
    var
        ApprovalMgt: Codeunit "CEM Approval Management";
    begin
        exit(ApprovalMgt.GetNextApprover(DATABASE::"CEM Per Diem", Format("Entry No.")));
    end;


    procedure CurrentUserIsNextApprover(): Boolean
    begin
        exit(UserId = NextApprover);
    end;
}

