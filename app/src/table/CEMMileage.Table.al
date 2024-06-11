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
    end;

    procedure ThrowInboxError()
    begin
    end;

    procedure SetSkipSendToExpUser(NewSkipSendToExpUser: Boolean)
    begin
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
    begin
    end;

    procedure PostingSetupChanged(var NewCalculatedAccount: Code[20]): Boolean
    begin
        NewCalculatedAccount := '';
    end;

    procedure Navigate()
    begin
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
    begin
    end;

    procedure LookupDimensions(Editable: Boolean)
    begin
    end;

    procedure LookupExtraFields(Editable: Boolean)
    begin
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
    begin
    end;

    procedure LookupComments()
    begin
    end;

    procedure DetachMilFromSettlement(var Mileage: Record "CEM Mileage")
    begin
    end;

    procedure AttachMilToSettlement(var Mileage: Record "CEM Mileage")
    begin
    end;

    procedure LookupExternalPostingAccount(var Text: Text[1024]): Boolean
    begin
        Text := '';
    end;

    procedure GetEarliestDate(): Date
    begin
    end;

    procedure DrillDownAttendees()
    begin
    end;

    procedure GetAttendeesForDisplay() DisplayTxt: Text[150]
    begin
    end;

    procedure GetTableCaptionPlural(): Text[250]
    begin
    end;

    procedure SplitAndAllocate()
    begin
    end;

    procedure DroveInCompanyCar(): Boolean
    begin
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

    end;


    procedure ShowDetails()
    var
        MilDetail: Record "CEM Mileage Detail";
    begin
        MilDetail.SetRange(MilDetail."Mileage Entry No.", "Entry No.");
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

    end;


    procedure DeductOfficeDistanceOrRevert(SkipValidate: Boolean)
    begin
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


        if not Confirm(Question, true) then
            exit;

        if Mileage.FindSet(true, false) then
            repeat
                Mileage2 := Mileage;
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
    end;


    procedure TestStatusOrUserAllowsChange()
    begin
    end;


    procedure ShouldHandleCASalesTax(): Boolean
    var
    begin
    end;


    procedure NextApprover(): Code[50]
    begin
    end;


    procedure CurrentUserIsNextApprover(): Boolean
    begin
        exit(UserId = NextApprover());
    end;
}

