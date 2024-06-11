table 6086338 "CEM Mileage"
{
    Caption = 'Mileage';
    DataCaptionFields = "Entry No.", "Continia User ID", "Vehicle Code", Description;
    Permissions = TableData "Default Dimension" = r,
                  TableData "CDC Continia User Setup" = r,
                  TableData "CEM Mileage Inbox" = r;

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
        field(5; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            NotBlank = true;
        }
        field(6; "Date Created"; Date)
        {
            Caption = 'Date Created';
            Editable = false;
        }
        field(7; "Created by User ID"; Code[50])
        {
            Caption = 'Created by User ID';
            Editable = false;
        }
        field(8; "From Address"; Text[250])
        {
            Caption = 'From Address';
        }
        field(9; "To Address"; Text[250])
        {
            Caption = 'To Address';
        }
        field(10; "Total Distance"; Decimal)
        {
            Caption = 'Total Distance';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            var
                MileageRate: Record "CEM Mileage Rate";
                Vehicle: Record "CEM Vehicle";
            begin
                TestField("Registration Date");
                TestStatusAllowsChange();

                if "Vehicle Code" = '' then
                    Validate("Vehicle Code", Vehicle.GetUserVehicle("Continia User ID"));

                if xRec."Total Distance" <> "Total Distance" then
                    if not (Status in [Status::Open, Status::"Pending Expense User"]) then
                        Error(ModifyNotAllowed, FieldCaption(Status), GetStatusCaption(Status::Open), GetStatusCaption(Status::"Pending Expense User"));

                if not HomeOfficeDistanceDeducted() then begin
                    "Original Total Distance" := "Total Distance";
                    DeductOfficeDistanceOrRevert(true);
                end;

                CalculateMileageDetails();
            end;
        }
        field(11; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(12; "Calculated Distance"; Decimal)
        {
            Caption = 'Calculated Distance';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(13; Billable; Boolean)
        {
            Caption = 'Billable';
        }
        field(14; "Vehicle Code"; Code[20])
        {
            Caption = 'Vehicle Code';
        }
        field(15; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
        }
        field(16; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
        }
        field(17; "Job No."; Code[20])
        {
            Caption = 'Job No.';
        }
        field(18; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
        }
        field(19; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(20; Comment; Boolean)
        {
            CalcFormula = exist("CEM Comment" where("Table ID" = const(6086338),
                                                     "Document Type" = const(Budget),
                                                     "Document No." = const(''),
                                                     "Doc. Ref. No." = field("Entry No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending Expense User,Pending Approval,Released';
            OptionMembers = Open,"Pending Expense User","Pending Approval",Released;

            trigger OnValidate()
            begin
                if "Entry No." <> 0 then
                    Validate("Calculated Distance");
            end;
        }
        field(22; "Current Reminder Level"; Integer)
        {
            CalcFormula = max("CEM Reminder"."No." where("Table ID" = const(6086338),
                                                          "Document Type" = const(Budget),
                                                          "Document No." = const(''),
                                                          "Doc. Ref. No." = field("Entry No.")));
            Caption = 'Current Reminder Level';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;

            trigger OnValidate()
            var
                MileageDetails: Record "CEM Mileage Detail";
            begin
                "Posted Date/Time" := CurrentDateTime;
                "Posted by User ID" := UserId;

                MileageDetails.SetRange("Mileage Entry No.", "Entry No.");
                if MileageDetails.FindSet() then
                    repeat
                        MileageDetails.Posted := Posted;
                        MileageDetails."Posted Date/Time" := "Posted Date/Time";
                        MileageDetails."Posted by User ID" := "Posted by User ID";
                        MileageDetails.Modify();
                    until MileageDetails.Next() = 0;
            end;
        }
        field(24; "Posted Date/Time"; DateTime)
        {
            Caption = 'Posted Date Time';
            Editable = false;
        }
        field(25; "Posted by User ID"; Code[50])
        {
            Caption = 'Posted by User ID';
            Editable = false;
        }
        field(26; "Mileage GUID"; Guid)
        {
            Caption = 'Mileage GUID';
        }
        field(27; "Transfer Attachments to CO"; Boolean)
        {
            Caption = 'Transfer Attachments to CO';
        }
        field(28; "Job Line Type"; Option)
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
        field(29; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
        field(30; "Vehicle Registration No."; Text[30])
        {
            Caption = 'Vehicle Registration No.';
        }
        field(31; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(32; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(41; "From Home"; Boolean)
        {
            Caption = 'From Home';
        }
        field(42; "To Home"; Boolean)
        {
            Caption = 'To Home';
        }
        field(43; "Register No."; Integer)
        {
            Caption = 'Register No.';
            TableRelation = "CEM Register";
        }
        field(50; "Travel Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Travel Time';
            DecimalPlaces = 0 : 2;
        }
        field(60; Reimbursed; Boolean)
        {
            Caption = 'Reimbursed';

            trigger OnValidate()
            var
                MileageDetails: Record "CEM Mileage Detail";
            begin
                MileageDetails.SetRange("Mileage Entry No.", "Entry No.");
                MileageDetails.ModifyAll(Reimbursed, Reimbursed);
            end;
        }
        field(61; "Reimbursement Register No."; Integer)
        {
            Caption = 'Reimbursement Register No.';
            TableRelation = "CEM Register";
        }
        field(62; "Reimbursement Method"; Option)
        {
            Caption = 'Reimbursement Method';
            OptionCaption = 'Internal (on User),External Payroll System,Both';
            OptionMembers = "Vendor (on User)","External System",Both;
        }
        field(63; "Entry No. (Code)"; Code[20])
        {
            Caption = 'Entry No. (Code)';
        }
        field(64; "Usage Entry No."; Integer)
        {
            Caption = 'Usage Entry No.';
            Editable = false;
        }
        field(65; "Employee Reimbursed"; Boolean)
        {
            Caption = 'Employee Reimbursed';
        }
        field(71; "Original Total Distance"; Decimal)
        {
            Caption = 'Original Total Distance';
        }
        field(72; "From Address Latitude"; Decimal)
        {
            Caption = 'From Latitude';
        }
        field(73; "From Address Longitude"; Decimal)
        {
            Caption = 'From Longitude';
        }
        field(74; "To Address Latitude"; Decimal)
        {
            Caption = 'To Latitude';
        }
        field(75; "To Address Longitude"; Decimal)
        {
            Caption = 'To Longitude';
        }
        field(76; "Notification Type"; Option)
        {
            Caption = 'Notification Type';
            OptionMembers = " ","New document","Important update","New history status";
        }
        field(103; "Expense Header GUID"; Guid)
        {
            Caption = 'Settlement GUID';
        }
        field(109; "Mileage Account Type"; Option)
        {
            Caption = 'Mileage Account Type';
            OptionCaption = ' ,G/L Account';
            OptionMembers = " ","G/L Account";
        }
        field(110; "Mileage Account"; Code[20])
        {
            Caption = 'Mileage Account';
        }
        field(111; "Mil. Account Manually Changed"; Boolean)
        {
            Caption = 'Mileage Account Manually Changed';
            Editable = false;
        }
        field(122; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(123; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(125; "Settlement No."; Code[20])
        {
            Caption = 'Settlement No.';
            TableRelation = "CEM Expense Header"."No." where("Document Type" = const(Settlement),
                                                              "Continia User ID" = field("Continia User ID"));

        }
        field(126; "Settlement Line No."; Integer)
        {
            Caption = 'Settlement Line No.';
        }
        field(127; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(128; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(210; "No Refund"; Boolean)
        {
            Caption = 'No Refund';

            trigger OnValidate()
            begin
                if (not "No Refund") and DroveInCompanyCar() then
                    TestField("No Refund", true);

                Validate("Total Distance");
            end;
        }
        field(213; "Created Doc. Type"; Integer)
        {
            Caption = 'Created Doc. Type';
            Editable = false;
        }
        field(214; "Created Doc. Subtype"; Integer)
        {
            Caption = 'Created Doc. Subtype';
            Editable = false;
        }
        field(215; "Created Doc. ID"; Code[20])
        {
            Caption = 'Created Doc. ID';
            Editable = false;
        }
        field(216; "Created Doc. Ref. No."; Integer)
        {
            Caption = 'Created Doc. Ref. No.';
            Editable = false;
        }
        field(217; "Mileage Completed"; Boolean)
        {
            Caption = 'Mileage Completed';
        }
        field(218; "Continia Online Version No."; Text[100])
        {
            Caption = 'Continia Online Version No.';
        }
        field(219; "Response from Dataloen"; Text[100])
        {
            Caption = 'Response from Dataloen';
        }
        field(260; "No. of Attachments"; Integer)
        {
            CalcFormula = count("CEM Attachment" where("Table ID" = const(6086338),
                                                        "Document Type" = const(Budget),
                                                        "Document No." = filter(''),
                                                        "Doc. Ref. No." = field("Entry No.")));
            Caption = 'Attachments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(270; "No. of Attendees"; Integer)
        {
            CalcFormula = count("CEM Attendee" where("Table ID" = const(6086338),
                                                      "Doc. Ref. No." = field("Entry No.")));
            Caption = 'No. of Attendees';
            Editable = false;
            FieldClass = FlowField;
        }
        field(271; "Updated By Delegation User"; Code[50])
        {
            Caption = 'Updated By Delegation User';
        }
        field(280; "External Posting Account Type"; Option)
        {
            Caption = 'External Posting Account Type';
            OptionCaption = ' ,Lessor Pay Type,Dataloen Pay Type';
            OptionMembers = " ","Lessor Pay Type","Dataloen Pay Type";

        }
        field(285; "External Posting Account No."; Code[20])
        {
            Caption = 'External Posting Account No.';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Mileage GUID")
        {
        }
        key(Key3; Posted, "Settlement No.")
        {
        }
        key(Key4; "Settlement No.", Posted, "Posted Date/Time")
        {
        }
        key(Key5; "Created Doc. Type", "Created Doc. Subtype", "Created Doc. ID", "Created Doc. Ref. No.")
        {
        }
        key(Key6; "Continia User ID", "Registration Date", Posted, Reimbursed, "Reimbursement Method")
        {
            SumIndexFields = "Total Distance", "Amount (LCY)";
        }
        key(Key7; "Register No.")
        {
        }
        key(Key8; "Reimbursement Register No.")
        {
        }
        key(Key9; Posted, "Continia User ID", Status, "Registration Date")
        {
        }
        key(Key10; "Continia User ID", Status, Posted, "Settlement No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key11; "Settlement No.", "Settlement Line No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key12; "Continia User ID", "Registration Date")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key13; "Continia User ID", "Registration Date", "Vehicle Code")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key14; "Continia User ID", "Registration Date", "From Home", "To Home")
        {
        }
    }

    var
        SkipSendToExpUser: Boolean;
        SuspendInboxCheck: Boolean;
        CannotChangeWhenSttl: Label '%1 cannot be changed when assigned to a settlement.';
        ConfirmDetachMileageMultiple: Label 'Do you want to detach %1 mileage from this settlement?';
        ConfirmDetachMileageSingle: Label 'Do you want to detach the mileage from this settlement?';
        DelegateUpdateTxt: Label 'Updated by delegated user %1.';
        EMInboxFoundErr: Label '%1 %2 cannot be updated as there are one or more unprocessed lines in the %3.\\Please process the related lines in the %3 before making changes to this %1.';
        FileAlreadyExistErr: Label 'The file name ''%1'' already exists for this mileage and cannot be imported.\\Please rename it before importing.';
        ModifyNotAllowed: Label '%1 must be %2 or %3.';
        NoMilInSelection: Label 'Please select one or more mileage to detach.';
        OneOrMoreInboxError: Label 'There are one or more unprocessed entries in the %1.';
        ProcessInboxAsapTxt: Label '\\You should process these as soon as possible.';
        RenameNotAllowed: Label 'You cannot rename a %1.';
        ReopenMultiplePendExpUsrQst: Label 'This will reopen %1 mileage entries.\Reopening a document can discard user''s changes when the Mobile App doesn''t have internet connection.\\Are you sure you want to continue?';
        ReopenMultipleQst: Label 'This will reopen %1 mileage entries.\Are you sure you want to continue?';
        ReopenSinglePendExpUsrQst: Label 'Reopening a document can discard user''s changes when the Mobile App doesn''t have internet connection.\\Are you sure you want to continue?';
        ReopenSingleQst: Label 'This will reopen this mileage entry.\Are you sure you want to continue?';
        SettlementReleasedErr: Label 'The settlement cannot be released.';
        SplitNotAllowdErr: Label 'Split and allocate is not supported for %1.';
        StatusNotAllowed: Label 'Status must be Open or Pending Expense User in %1 %2.';
        VehicleLimitTimedTxt: Label 'Your company policy defines a limit of %2 %3 per %4 for Vehicle %1.';
        VehicleLimitTxt: Label 'Your company policy defines a limit of %2 %3 per document for Vehicle %1.';
        WrongReimbursementMethod: Label '%1 should be %2 or %3, when %4 is used.';


    procedure NextReminderDate(): Date
    var
        EMReminder: Record "CEM Reminder";
    begin
        exit(EMReminder.NextReminderDate("Continia User ID", DATABASE::"CEM Mileage", 0, "Settlement No.", "Entry No.", GetEarliestDate()));
    end;


    procedure ShowReminders()
    begin
    end;


    procedure SetSuspendInboxCheck(NewSuspend: Boolean)
    begin
        SuspendInboxCheck := NewSuspend;
    end;


    procedure ExistsInInbox(): Boolean
    var
        MileageInbox: Record "CEM Mileage Inbox";
    begin
        MileageInbox.SetCurrentKey("Mileage GUID");
        MileageInbox.SetRange("Mileage GUID", "Mileage GUID");
        MileageInbox.SetFilter(Status, '%1|%2', MileageInbox.Status::Pending, MileageInbox.Status::Error);
        if not MileageInbox.IsEmpty then
            exit(true);
    end;


    procedure CheckInboxAndThrowError()
    begin
        if not SuspendInboxCheck then
            if ExistsInInbox() then
                ThrowInboxError();
    end;


    procedure ThrowInboxError()
    var
        MileageInbox: Record "CEM Mileage Inbox";
    begin
        Error(EMInboxFoundErr, TableCaption, "Entry No.", MileageInbox.TableCaption);
    end;


    procedure SetSkipSendToExpUser(NewSkipSendToExpUser: Boolean)
    begin
        SkipSendToExpUser := NewSkipSendToExpUser;
    end;


    procedure AddDefaultDim(ValidatedFieldNo: Integer)
    begin
    end;

    procedure HasMileageComment(): Boolean
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
        ApprovalCmtLine.SetRange("Table ID", DATABASE::"CEM Mileage");
        ApprovalCmtLine.SetRange("Document Type", ApprovalCmtLine."Document Type"::Invoice);
        ApprovalCmtLine.SetRange("Document No.", Format("Entry No."));
        exit(not ApprovalCmtLine.IsEmpty);
    end;


    procedure CheckUnProcessedInbox()
    var
        MileageInbox: Record "CEM Mileage Inbox";
        ReleaseNotificationEntry: Record "CEM Release Notification Entry";
        UserDelegation: Record "CEM User Delegation";
        NAVversionMgt: Codeunit "CEM NAV-version Mgt.";
        TextMessage: Text[1024];
    begin
        if UserDelegation.GetDelegationFilter() <> '' then
            exit;

        MileageInbox.SetFilter(Status, '<>%1', MileageInbox.Status::Accepted);
        if not MileageInbox.IsEmpty then
            TextMessage := StrSubstNo(OneOrMoreInboxError, MileageInbox.TableCaption);

        if ReleaseNotificationEntry.CheckForUnprocessedEntries() then begin
            if TextMessage <> '' then
                TextMessage := TextMessage + '\\';
            TextMessage := TextMessage + StrSubstNo(OneOrMoreInboxError, ReleaseNotificationEntry.TableCaption);
        end;

        if ReleaseNotificationEntry.CheckForUnprocessedHistEntries() then
            NAVversionMgt.SendHistoryToCO(false);

        if TextMessage <> '' then
            Message(TextMessage + ProcessInboxAsapTxt);
    end;

    local procedure GetStatusCaption(StatusAsInt: Integer): Text[30]
    var
        Mileage: Record "CEM Mileage";
    begin
        Mileage.Status := StatusAsInt;
        exit(Format(Mileage.Status));
    end;


    procedure PostingSetupChanged(var NewCalculatedAccount: Code[20]): Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        ExpensePostingSetup: Record "CEM Posting Setup";
    begin
        if "Mil. Account Manually Changed" then
            exit(false);

        if not ContiniaUserSetup.Get("Continia User ID") then
            exit(false);

        ExpensePostingSetup.FindPostingSetup(DATABASE::"CEM Mileage", "Vehicle Code", '', "Continia User ID",
          ContiniaUserSetup."Expense User Group", false);
        NewCalculatedAccount := ExpensePostingSetup."Posting Account No.";
        exit("Mileage Account" <> NewCalculatedAccount);
    end;

    local procedure SetAccount()
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        ExpPostingSetup: Record "CEM Posting Setup";
    begin
        if not ContiniaUserSetup.Get("Continia User ID") then
            Clear(ContiniaUserSetup);

        if ExpPostingSetup.FindPostingSetup(DATABASE::"CEM Mileage", "Vehicle Code", '', "Continia User ID",
          ContiniaUserSetup."Expense User Group", false)
        then begin
            "Mileage Account Type" := ExpPostingSetup."Posting Account Type";
            "Mileage Account" := ExpPostingSetup."Posting Account No.";
            "External Posting Account Type" := ExpPostingSetup."External Posting Account Type";
            "External Posting Account No." := ExpPostingSetup."External Posting Account No.";
            "Gen. Prod. Posting Group" := ExpPostingSetup."Gen. Prod. Posting Group";
            "VAT Prod. Posting Group" := ExpPostingSetup."VAT Prod. Posting Group";
            "Gen. Bus. Posting Group" := ExpPostingSetup."Gen. Bus. Posting Group";
            "VAT Bus. Posting Group" := ExpPostingSetup."VAT Bus. Posting Group";
            "Tax Group Code" := ExpPostingSetup."Tax Group Code";
        end else begin
            Clear("Mileage Account Type");
            Clear("Mileage Account");
            Clear("External Posting Account Type");
            Clear("External Posting Account No.");
            Clear("Gen. Prod. Posting Group");
            Clear("VAT Prod. Posting Group");
            Clear("Gen. Bus. Posting Group");
            Clear("VAT Bus. Posting Group");
            Clear("Tax Group Code");
        end;

        "Mil. Account Manually Changed" := false;

        MilValidate.Run(Rec);
    end;


    procedure Navigate()
    var
        NavigateMileage: Codeunit "CEM Navigate Mileage - Find";
    begin
        NavigateMileage.NavigateMileage(Rec);
    end;


    procedure GetEntryNo(): Integer
    var
        Mileage: Record "CEM Mileage";
    begin
        if Mileage.FindLast() then
            exit(Mileage."Entry No." + 1)
        else
            exit(1);
    end;

    local procedure InitMileage()
    begin
        if "Continia User ID" = '' then
            "Continia User ID" := UserId;

        if "Registration Date" = 0D then
            "Registration Date" := WorkDate();

        Validate("Reimbursement Method", GetReimbursMethodForRecUsr());
    end;


    procedure MileageBetweenVarianceLimits(): Boolean
    var
        EMSetup: Record "CEM Expense Management Setup";
        HighVarianceAllowed: Decimal;
        LowVarianceAllowed: Decimal;
    begin
        if "Calculated Distance" = 0 then
            exit(true);

        EMSetup.Get();
        HighVarianceAllowed := "Calculated Distance" * (100 + EMSetup."Distance Variance % Allowed") / 100;
        LowVarianceAllowed := "Calculated Distance" * (100 - EMSetup."Distance Variance % Allowed") / 100;

        exit(("Total Distance" >= LowVarianceAllowed) and ("Total Distance" <= HighVarianceAllowed));
    end;


    procedure SendToExpenseUser()
    var
        SendToExpUser: Codeunit "CEM Mileage - Send to User";
    begin
        if SkipSendToExpUser then
            exit;

        if Status = Status::"Pending Expense User" then
            SendToExpUser.UpdateWithoutFiles(Rec);
    end;


    procedure LookupDimensions(Editable: Boolean)
    var
        Mileage: Record "CEM Mileage";
    begin
        if Mileage.Get("Entry No.") then
            DrillDownDimensions(PAGE::"CEM Dimensions", Editable);
    end;


    procedure LookupExtraFields(Editable: Boolean)
    var
        Mileage: Record "CEM Mileage";
    begin
        if Mileage.Get("Entry No.") then
            DrillDownDimensions(PAGE::"CEM Extra Fields", Editable);
    end;

    local procedure DrillDownDimensions(FormID: Integer; Editable: Boolean)
    var
        EMDim: Record "CEM Dimension";
        TempEMDim: Record "CEM Dimension" temporary;
        ExpDim: Page "CEM Dimensions";
        ExpExtraFields: Page "CEM Extra Fields";
    begin
        EMDim.SetRange("Table ID", DATABASE::"CEM Mileage");
        EMDim.SetRange("Document Type", 0);
        EMDim.SetRange("Document No.", '');
        EMDim.SetRange("Doc. Ref. No.", "Entry No.");

        if (not Posted) and StatusOrUserAllowsChange() and Editable then begin
            if EMDim.FindSet() then
                repeat
                    TempEMDim := EMDim;
                    TempEMDim.Insert();
                until EMDim.Next() = 0;

            TempEMDim.SetRange("Table ID", DATABASE::"CEM Mileage");
            TempEMDim.SetRange("Document Type", 0);
            TempEMDim.SetRange("Document No.", '');
            TempEMDim.SetRange("Doc. Ref. No.", "Entry No.");

            PAGE.RunModal(FormID, TempEMDim);

            if EMDim.EMDimUpdated(TempEMDim, DATABASE::"CEM Mileage", 0, '', "Entry No.") then begin
                EMDim.DeleteAll(true);

                if TempEMDim.FindSet() then
                    repeat
                        EMDim := TempEMDim;
                        EMDim.Insert(true);
                    until TempEMDim.Next() = 0;

                Get("Entry No.");
                SendToExpenseUser();

                CODEUNIT.Run(CODEUNIT::"CEM Mileage-Validate", Rec);
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


    procedure ShowAttachments()
    var
        EMAttachment: Record "CEM Attachment";
    begin
        EMAttachment.SetRange("Table ID", DATABASE::"CEM Mileage");
        EMAttachment.SetRange("Document Type", 0);
        EMAttachment.SetRange("Document No.", '');
        EMAttachment.SetRange("Doc. Ref. No.", "Entry No.");
        PAGE.RunModal(0, EMAttachment);
    end;


    procedure GetOverviewDetails() AddInfo: Text[250]
    begin
        if "From Address" <> '' then
            AddTextTo(AddInfo, FieldCaption("From Address") + ': ' + "From Address");

        if "To Address" <> '' then
            AddTextTo(AddInfo, FieldCaption("To Address") + ': ' + "To Address");

        if "No Refund" then
            AddTextTo(AddInfo, FieldCaption("No Refund"));
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


    procedure GetNextDocumentLineNo() LineNo: Integer
    var
        Mileage: Record "CEM Expense";
    begin
        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", "Settlement No.");
        Mileage.SetFilter("Entry No.", '<>%1', "Entry No.");
        if Mileage.FindLast() then
            exit(Mileage."Settlement Line No." + 10000);

        exit(10000);
    end;


    procedure OpenDocumentCard()
    var
        Settlement: Record "CEM Expense Header";
        MileageCard: Page "CEM Mileage Card";
        PostedMileageCard: Page "CEM Posted Mileage Card";
    begin
        if Settlement.Get(Settlement."Document Type"::Settlement, "Settlement No.") then
            Settlement.OpenDocumentCard
        else
            if Posted then begin
                PostedMileageCard.SetRecord(Rec);
                PostedMileageCard.LockToSpecificDocumentNo("Entry No.");
                PostedMileageCard.Run;
            end else begin
                MileageCard.SetRecord(Rec);
                MileageCard.LockToSpecificDocumentNo("Entry No.");
                MileageCard.Run;
            end;
    end;


    procedure LookupComments()
    var
        EMCmtMgt: Codeunit "CEM Comment Mgt.";
    begin
        EMCmtMgt.LookupComments(DATABASE::"CEM Mileage", 0, '', "Entry No.");
    end;


    procedure DetachMilFromSettlement(var Mileage: Record "CEM Mileage")
    var
        Mileage2: Record "CEM Mileage";
        ConfirmText: Text[1024];
    begin
        if Mileage.Count = 0 then
            Error(NoMilInSelection);

        if Mileage.Count = 1 then
            ConfirmText := ConfirmDetachMileageSingle
        else
            ConfirmText := StrSubstNo(ConfirmDetachMileageMultiple, Mileage.Count);

        if Confirm(ConfirmText) then
            if Mileage.FindSet() then
                repeat
                    Mileage2.Get(Mileage."Entry No.");
                    Mileage2.Validate("Settlement No.", '');
                    Mileage2.Modify(true);
                until Mileage.Next() = 0;
    end;


    procedure AttachMilToSettlement(var Mileage: Record "CEM Mileage")
    var
        ExpHeader: Record "CEM Expense Header";
        Mileage2: Record "CEM Mileage";
    begin
        if Mileage.Count = 0 then
            Error(NoMilInSelection);

        Mileage.FindFirst();

        ExpHeader.FilterGroup(4);
        ExpHeader.SetRange("Continia User ID", Mileage."Continia User ID");
        ExpHeader.SetFilter(Status, '%1|%2', ExpHeader.Status::Open, ExpHeader.Status::"Pending Expense User");
        ExpHeader.FilterGroup(0);
        if PAGE.RunModal(PAGE::"CEM Settlement List", ExpHeader) = ACTION::LookupOK then
            repeat
                Mileage.TestStatusAllowsChange();
                Mileage2.Get(Mileage."Entry No.");
                Mileage2.Validate("Settlement No.", ExpHeader."No.");
                Mileage2.Modify(true);
            until Mileage.Next() = 0;
    end;


    procedure LookupExternalPostingAccount(var Text: Text[1024]): Boolean
    var
        DataloenIntegration: Codeunit "CEM Dataloen Integration";
        LessorIntegration: Codeunit "CEM Lessor Integration";
    begin
        TestField("External Posting Account Type");
        case "External Posting Account Type" of
            "External Posting Account Type"::"Lessor Pay Type":
                exit(LessorIntegration.LookupPayType(Text));

            "External Posting Account Type"::"Dataloen Pay Type":
                exit(DataloenIntegration.LookupPayType(Text));
        end;
    end;


    procedure GetEarliestDate(): Date
    begin
        //BETWEEN DOCUMENT DATE AND DATE CREATED

        if "Registration Date" = 0D then
            exit("Date Created");

        if "Date Created" = 0D then
            exit("Registration Date");

        if "Date Created" < "Registration Date" then
            exit("Date Created")
        else
            exit("Registration Date");
    end;


    procedure DrillDownAttendees()
    var
        ExpAttendee: Record "CEM Attendee";
        TempExpAttendee: Record "CEM Attendee" temporary;
        MileageRate: Record "CEM Mileage Rate";
        ExpAttendees: Page "CEM Mileage Attendees";
    begin
        ExpAttendee.SetRange("Table ID", DATABASE::"CEM Mileage");
        ExpAttendee.SetRange("Doc. Ref. No.", "Entry No.");

        if not Posted then begin
            if ExpAttendee.FindSet() then
                repeat
                    TempExpAttendee := ExpAttendee;
                    TempExpAttendee.Insert();
                until ExpAttendee.Next() = 0;

            TempExpAttendee.SetRange("Table ID", DATABASE::"CEM Mileage");
            TempExpAttendee.SetRange("Doc. Ref. No.", "Entry No.");
            PAGE.RunModal(6086334, TempExpAttendee);
            if TempExpAttendee.AttendeesUpdated(TempExpAttendee, "Entry No.", DATABASE::"CEM Mileage") then begin
                ExpAttendee.DeleteAll();

                if TempExpAttendee.FindSet() then
                    repeat
                        ExpAttendee := TempExpAttendee;
                        ExpAttendee.Insert();
                    until TempExpAttendee.Next() = 0;

                Get("Entry No.");
                SendToExpenseUser();

                CODEUNIT.Run(CODEUNIT::"CEM Mileage-Validate", Rec);
                CalculateMileageDetails();
            end;
        end else begin
            ExpAttendees.SetTableView(ExpAttendee);
            ExpAttendees.Editable := false;
            ExpAttendees.RunModal;
        end;
    end;


    procedure GetAttendeesForDisplay() DisplayTxt: Text[150]
    var
        ExpAttendee: Record "CEM Attendee";
    begin
        exit(ExpAttendee.GetAttendeesForDisplay(DATABASE::"CEM Mileage", "Entry No."));
    end;


    procedure GetTableCaptionPlural(): Text[250]
    begin
        exit(TableCaption);
    end;


    procedure SplitAndAllocate()
    begin
        Error(SplitNotAllowdErr, TableCaption);
    end;


    procedure DroveInCompanyCar(): Boolean
    var
        Vehicle: Record "CEM Vehicle";
    begin
        if Vehicle.Get("Vehicle Code") then
            exit(Vehicle."Company Car");
    end;


    procedure CalculateMileageDetails()
    var
        MileageRate: Record "CEM Mileage Rate";
        IsHandled: Boolean;
    begin
        OnBeforeCalcMileageDetails(Rec, IsHandled);
        if not IsHandled then
            MileageRate.CalcMileageDetails(Rec, true);
        OnAfterCalcMileageDetails(Rec);
    end;


    procedure AddAttachment(var TempFile: Record "CDC Temp File" temporary; Changeable: Boolean)
    var
        EMAttachment: Record "CEM Attachment";
    begin
        CheckInboxAndThrowError();
        if not TempFile.Data.HasValue then
            exit;

        EMAttachment.CheckFileNameLen(TempFile.Name);

        EMAttachment.SetRange("Table ID", DATABASE::"CEM Mileage");
        EMAttachment.SetRange("Document Type", 0);
        EMAttachment.SetRange("Document No.", '');
        EMAttachment.SetRange("Doc. Ref. No.", "Entry No.");
        EMAttachment.SetRange("File Name", TempFile.Name);
        if not EMAttachment.IsEmpty then
            Error(FileAlreadyExistErr, TempFile.Name);

        EMAttachment.SetRange("File Name");

        EMAttachment.Init();
        EMAttachment."Table ID" := DATABASE::"CEM Mileage";
        EMAttachment."Document No." := '';
        EMAttachment."Doc. Ref. No." := "Entry No.";
        EMAttachment."File Name" := TempFile.Name;
        EMAttachment.Changeable := Changeable;
        EMAttachment.Insert(true);

        EMAttachment.SetAttachment(TempFile, true);
        EMAttachment.ConvertToPagesAndStore();

        MilValidate.Run(Rec);
    end;


    procedure ShowDetails()
    var
        MilDetail: Record "CEM Mileage Detail";
    begin
        MilDetail.SetRange(MilDetail."Mileage Entry No.", "Entry No.");
        PAGE.Run(PAGE::"CEM Mileage Details", MilDetail);
    end;


    procedure GetReimbursMethodForRecUsr(): Integer
    var
        DefaultUserSetup: Record "CEM Default User Setup";
    begin
        exit(DefaultUserSetup.GetMilReimbursMethodForUser("Continia User ID"));
    end;


    procedure GetRecordID(var RecID: RecordID)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        RecID := RecRef.RecordId;
        RecRef.Close();
    end;


    procedure EmployeeReimbExpectedInBC(): Boolean
    begin
        if DroveInCompanyCar() then
            exit(false);

        exit("Reimbursement Method" = "Reimbursement Method"::"Vendor (on User)");
    end;


    procedure GetExternalDocNo(): Code[20]
    begin
        exit(StrSubstNo('%1 %2', TableCaption, Format("Entry No.")));
    end;


    procedure CheckWarningPolicyAndGetCmt(var CommentTxt: Text[250]): Boolean
    var
        CompanyPolicy: Record "CEM Company Policy";
    begin
        if not CompanyPolicy.GetWarningCommentPolicy(DATABASE::"CEM Mileage", "Continia User ID", "Vehicle Code") then
            exit(false);

        exit(CheckPolicyAndGetCmt(CompanyPolicy, CommentTxt));
    end;


    procedure CheckPolicyAndGetCmt(CompanyPolicy: Record "CEM Company Policy"; var CommentTxt: Text[250]): Boolean
    var
        EMSetup: Record "CEM Expense Management Setup";
        GLSetup: Record "General Ledger Setup";
        TimeSpecified: Boolean;
        EndDate: Date;
        StartDate: Date;
    begin
        CompanyPolicy.GetTimeIntervalStartAndEndDate("Registration Date", StartDate, EndDate);
        EMSetup.Get();

        if GetMilBalOnUserForDateInterval(StartDate, EndDate) > CompanyPolicy.Distance then begin
            GLSetup.Get();
            TimeSpecified := CompanyPolicy."Period of Time" <> CompanyPolicy."Period of Time"::" ";

            // Limits on an Vehicle level
            if (CompanyPolicy."Document Type" <> CompanyPolicy."Document Type"::" ") and
              (CompanyPolicy."Document Account No." <> '') then begin
                if TimeSpecified then
                    CommentTxt := StrSubstNo(VehicleLimitTxt, "Vehicle Code", CompanyPolicy.Distance,
                      Format(EMSetup."Distance Unit"), LowerCase(Format(CompanyPolicy."Period of Time")))
                else
                    CommentTxt := StrSubstNo(VehicleLimitTxt, "Vehicle Code", CompanyPolicy.Distance, Format(EMSetup."Distance Unit"));

                exit(true);
            end;
        end;
    end;


    procedure CheckApproveBelowLimit(var LimitDistance: Decimal): Boolean
    var
        CompanyPolicy: Record "CEM Company Policy";
        GLSetup: Record "General Ledger Setup";
        EndDate: Date;
        StartDate: Date;
    begin
        if not CompanyPolicy.GetApproveBelowPolicy(DATABASE::"CEM Mileage", "Continia User ID", "Vehicle Code") then
            exit(false);

        CompanyPolicy.GetTimeIntervalStartAndEndDate("Registration Date", StartDate, EndDate);
        LimitDistance := CompanyPolicy.Distance;
        exit(GetMilBalOnUserForDateInterval(StartDate, EndDate) <= CompanyPolicy.Distance);
    end;


    procedure CheckRefundWithinLimit(var CompanyPolicy: Record "CEM Company Policy"): Boolean
    var
        EndDate: Date;
        StartDate: Date;
        BalanceDistance: Decimal;
    begin
        if not CompanyPolicy.GetRefundWithinPolicy(DATABASE::"CEM Mileage", "Continia User ID", "Vehicle Code") then
            exit(false);

        CompanyPolicy.GetTimeIntervalStartAndEndDate("Registration Date", StartDate, EndDate);
        BalanceDistance := GetMilBalOnUserForDateInterval(StartDate, EndDate);
        exit(BalanceDistance > CompanyPolicy.Distance);
    end;


    procedure GetMilBalOnUserForDateInterval(StartDate: Date; EndDate: Date): Decimal
    var
        Mileage: Record "CEM Mileage";
    begin
        if (StartDate <> 0D) and (EndDate <> 0D) then begin
            Mileage.SetCurrentKey("Continia User ID", "Registration Date", "Vehicle Code");
            Mileage.SetRange("Continia User ID", Rec."Continia User ID");
            Mileage.SetRange("Registration Date", StartDate, EndDate);
            Mileage.SetRange("Vehicle Code", "Vehicle Code");
            Mileage.SetFilter("Entry No.", '<>%1', Rec."Entry No."); // Exclude current (potentially) un-commited rec.
            Mileage.CalcSums("Total Distance");
            exit(Mileage."Total Distance" + Rec."Total Distance"); // Add Current Rec Amount
        end else
            exit(Rec."Total Distance");
    end;


    procedure CoordinatesExistOnMileage(): Boolean
    begin
        exit((Rec."From Address Latitude" > 0) and (Rec."From Address Longitude" > 0) and (Rec."To Address Latitude" > 0) and (Rec."To Address Longitude" > 0));
    end;


    procedure HomeOfficeDistanceDeducted(): Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        EMSetup: Record "CEM Expense Management Setup";
        Vehicle: Record "CEM Vehicle";
        Math: Codeunit "CEM Math";
    begin
        if not (Rec."From Home" or Rec."To Home") then
            exit;

        EMSetup.Get();
        if (not EMSetup."Deduct home-office distance") then
            exit;

        ContiniaUserSetup.Get(Rec."Continia User ID");
        if (ContiniaUserSetup."Distance from home to office" = 0) then
            exit;

        Vehicle.Get("Vehicle Code");
        if Vehicle."Company Car" then
            exit;

        exit(Rec."Total Distance" = Math.Max(0, Rec."Original Total Distance" - ContiniaUserSetup."Distance from home to office"));
    end;


    procedure DeductOfficeDistanceOrRevert(SkipValidate: Boolean)
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        EMSetup: Record "CEM Expense Management Setup";
        Vehicle: Record "CEM Vehicle";
        Math: Codeunit "CEM Math";
    begin
        EMSetup.Get();

        if not EMSetup."Deduct home-office distance" then
            exit;

        if not ContiniaUserSetup.Get(Rec."Continia User ID") then
            exit;

        if not Vehicle.Get("Vehicle Code") then
            exit;

        if (Rec."From Home" or Rec."To Home") and (not Vehicle."Company Car") and (ContiniaUserSetup."Distance from home to office" > 0) then begin
            if Rec."Total Distance" = Rec."Original Total Distance" then
                if SkipValidate then
                    Rec."Total Distance" := Math.Max(0, Rec."Original Total Distance" - ContiniaUserSetup."Distance from home to office")
                else
                    Rec.Validate("Total Distance", Math.Max(0, Rec."Original Total Distance" - ContiniaUserSetup."Distance from home to office"));
        end else
            if Rec."Total Distance" <> Rec."Original Total Distance" then
                if SkipValidate then
                    Rec."Total Distance" := Rec."Original Total Distance"
                else
                    Rec.Validate("Total Distance", Rec."Original Total Distance");
    end;


    procedure GetRefundableDistance() RefundableDistance: Decimal
    var
        MileageDetails: Record "CEM Mileage Detail";
    begin
        if "No Refund" then
            exit;

        MileageDetails.SetRange("Mileage Entry No.", "Entry No.");
        if MileageDetails.FindSet() then
            repeat
                RefundableDistance += MileageDetails.Distance;
            until MileageDetails.Next() = 0;
    end;


    procedure GetRefundableAmount() RefundableAmtLCY: Decimal
    var
        MileageDetails: Record "CEM Mileage Detail";
    begin
        if "No Refund" then
            exit;

        MileageDetails.SetRange("Mileage Entry No.", "Entry No.");
        if MileageDetails.FindSet() then
            repeat
                RefundableAmtLCY += MileageDetails."Amount (LCY)";
            until MileageDetails.Next() = 0;
    end;

    [IntegrationEvent(false, false)]

    procedure OnBeforeCalcMileageDetails(var Mileage: Record "CEM Mileage"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterCalcMileageDetails(var Mileage: Record "CEM Mileage")
    begin
    end;


    procedure GetEmployeeEmailDep(): Text[250]
    begin
    end;


    procedure ReopenMileage(var Mileage: Record "CEM Mileage")
    var
        Mileage2: Record "CEM Mileage";
        PendingExpUserFound: Boolean;
        Question: Text[1024];
    begin
        // Do we have pending expense user records?
        Mileage.SetRange(Status, Mileage.Status::"Pending Expense User");
        PendingExpUserFound := not Mileage.IsEmpty;
        Mileage.SetRange(Status);

        if Mileage.Count = 1 then begin
            if PendingExpUserFound then
                Question := ReopenSinglePendExpUsrQst
            else
                Question := ReopenSingleQst;
        end else
            if PendingExpUserFound then
                Question := StrSubstNo(ReopenMultiplePendExpUsrQst, Mileage.Count)
            else
                Question := StrSubstNo(ReopenMultipleQst, Mileage.Count);

        if not Confirm(Question, true) then
            exit;

        if Mileage.FindSet(true, false) then
            repeat
                Mileage2 := Mileage;
                CODEUNIT.Run(CODEUNIT::"CEM Mileage - Complete", Mileage2);
            until Mileage.Next() = 0;
    end;


    procedure StatusAllowsChange() Condition: Boolean
    begin
        Condition := Status in [Status::Open, Status::"Pending Expense User"];
    end;


    procedure StatusOrUserAllowsChange() Condition: Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        Condition := StatusAllowsChange() or ContiniaUserSetup.CanEditApprovedDocuments(UserId);
    end;


    procedure TestStatusAllowsChange()
    begin
        if not StatusAllowsChange() then
            Error(StatusNotAllowed, TableCaption, "Entry No.");
    end;


    procedure TestStatusOrUserAllowsChange()
    begin
        if not StatusOrUserAllowsChange() then
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


    procedure NextApprover(): Code[50]
    var
        ApprovalMgt: Codeunit "CEM Approval Management";
    begin
        exit(ApprovalMgt.GetNextApprover(DATABASE::"CEM Mileage", Format("Entry No.")));
    end;


    procedure CurrentUserIsNextApprover(): Boolean
    begin
        exit(UserId = NextApprover());
    end;
}

