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
                    EMSetup.Get;
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
                CheckLinesExist;

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
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            var
                EMDimMgt: Codeunit "CEM Dimension Mgt.";
            begin
                EMDimMgt.UpdateEMDimForGlobalDim(DATABASE::"CEM Expense Header", "Document Type", "No.", 0, 1, "Global Dimension 1 Code");
                ExpHeaderValidate.Run(Rec);
            end;
        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            var
                EMDimMgt: Codeunit "CEM Dimension Mgt.";
            begin
                EMDimMgt.UpdateEMDimForGlobalDim(DATABASE::"CEM Expense Header", "Document Type", "No.", 0, 2, "Global Dimension 2 Code");
                ExpHeaderValidate.Run(Rec);
            end;
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
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

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

            trigger OnValidate()
            begin
                "Posted Date/Time" := CurrentDateTime;
                "Posted by User ID" := UserId;
            end;
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
            CalcFormula = Exist("CEM Comment Line" WHERE("Table Name" = CONST("Expense Header"),
                                                          "No." = FIELD("No.")));
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

            trigger OnValidate()
            begin
                CheckDates;
                ExpHeaderValidate.Run(Rec);
            end;
        }
        field(28; "Return Date/Time"; DateTime)
        {
            Caption = 'Return Date/Time';

            trigger OnValidate()
            begin
                CheckDates;
                ExpHeaderValidate.Run(Rec);
            end;
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
        field(100; "Expense Total (LCY)"; Decimal)
        {
            CalcFormula = Sum("CEM Expense"."Amount (LCY)" WHERE("Settlement No." = FIELD("No.")));
            Caption = 'Expense Total (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Mileage Total (LCY)"; Decimal)
        {
            CalcFormula = Sum("CEM Mileage"."Amount (LCY)" WHERE("Settlement No." = FIELD("No.")));
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
            TableRelation = "CDC Continia User Setup";

            trigger OnValidate()
            var
                EMComment: Record "CEM Comment";
                CmtMgt: Codeunit "CEM Comment Mgt.";
            begin
                if ("Updated By Delegation User" <> '') and (Rec."Updated By Delegation User" <> "Updated By Delegation User") then
                    CmtMgt.AddComment(DATABASE::"CEM Expense Header", "Document Type", "No.", 0, EMComment.Importance::Information, 'DELEGATIONUPDATED',
                      StrSubstNo(DelegateUpdateTxt, "Continia User ID"), false);
            end;
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

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        EMComment: Record "CEM Comment";
        EMCommentLine: Record "CEM Comment Line";
        EMDimension: Record "CEM Dimension";
        Expense: Record "CEM Expense";
        Expense2: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
        EMReminder: Record "CEM Reminder";
        EMApprovalsBridge: Codeunit "CEM Approvals Bridge";
        EMOnlineMgt: Codeunit "CEM Online Synch. Mgt.";
    begin
        TestField(Posted, false);
        TestStatusAllowsChange;
        CheckInboxAndThrowError;

        Expense.SetCurrentKey("Settlement No.");
        Expense.SetRange("Settlement No.", "No.");
        Expense.SetRange("Matched to Bank Transaction", false);

        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", "No.");

        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", "No.");

        if not HideUI then
            if not (Expense.IsEmpty and Mileage.IsEmpty and PerDiem.IsEmpty) then
                if not Confirm(DeleteSettlementTxt, false) then
                    Error('');

        Expense.SetRange("Matched to Bank Transaction", true);
        if Expense.FindFirst then
            repeat
                Expense2 := Expense;
                Expense2.Validate("Settlement No.", '');
                Expense2.Modify(true);
            until Expense.Next = 0;

        Expense.SetRange("Matched to Bank Transaction", false);
        Expense.DeleteAll(true);
        Mileage.DeleteAll(true);
        PerDiem.DeleteAll(true);

        EMDimension.LockTable;
        EMDimension.SetCurrentKey("Table ID", "Document Type", "Document No.", "Doc. Ref. No.");
        EMDimension.SetRange("Table ID", DATABASE::"CEM Expense Header");
        EMDimension.SetRange("Document Type", EMDimension."Document Type"::Settlement);
        EMDimension.SetRange("Document No.", "No.");
        EMDimension.SetRange("Doc. Ref. No.", 0);
        EMDimension.DeleteAll;

        EMComment.SetCurrentKey("Table ID", "Document Type", "Document No.", "Doc. Ref. No.");
        EMComment.SetRange("Table ID", DATABASE::"CEM Expense Header");
        EMComment.SetRange("Document Type", EMDimension."Document Type"::Settlement);
        EMComment.SetRange("Document No.", "No.");
        EMComment.SetRange("Doc. Ref. No.", 0);
        EMComment.DeleteAll(true);

        EMReminder.SetCurrentKey("Table ID", "Document Type", "Document No.", "Doc. Ref. No.");
        EMReminder.SetRange("Table ID", DATABASE::"CEM Expense Header");
        EMReminder.SetRange("Document Type", EMReminder."Document Type"::Settlement);
        EMReminder.SetRange("Document No.", "No.");
        EMReminder.SetRange("Doc. Ref. No.", 0);
        EMReminder.DeleteAll(true);

        EMCommentLine.SetRange("Table Name", EMCommentLine."Table Name"::"Expense Header");
        EMCommentLine.SetRange("No.", "No.");
        EMCommentLine.DeleteAll(true);

        EMApprovalsBridge.DeleteApprovalEntries(DATABASE::"CEM Expense Header", "No.");

        if Status = Status::"Pending Expense User" then
            EMOnlineMgt.PhysicalDeleteDocFromCO(DATABASE::"CEM Expense Header", "Exp. Header GUID", true);
    end;

    trigger OnInsert()
    var
        EMSetup: Record "CEM Expense Management Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        EMSetup.Get;
        EMSetup.TestSettlementEnabled;

        if "No." = '' then begin
            EMSetup.TestField("Settlement Nos.");
            NoSeriesMgt.InitSeries(EMSetup."Settlement Nos.", xRec."No. Series", WorkDate, "No.", "No. Series");
        end;

        AddDefaultDim(0);

        "Posting Date" := WorkDate;
        "Date Created" := Today;
        "Created by User ID" := UserId;

        if SalesSetup.Get then
            if SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" then
                "Posting Date" := 0D;

        "Posting Description" := Format("Document Type") + ' ' + "No.";

        // Send notification in the app
        "Notification Type" := "Notification Type"::"New document";

        ExpHeaderValidate.Run(Rec);
    end;

    trigger OnModify()
    begin
        TestField(Posted, false);
        TestStatusOrUserAllowsChange;
        CheckInboxAndThrowError;

        SendToExpenseUser;
    end;

    trigger OnRename()
    begin
        Error(CannotRename, TableCaption);
    end;

    var
        ExpHeaderValidate: Codeunit "CEM Settlement - Validate";
        HideUI: Boolean;
        SkipSendToExpUser: Boolean;
        SuspendInboxCheck: Boolean;
        CannotModifyField: Label '%1 cannot be modified because one or more lines exist.';
        CannotRename: Label 'You cannot rename a %1.';
        DateErr: Label '%1 cannot be later than %2.';
        DelegateUpdateTxt: Label 'Updated by delegated user %1.';
        DeleteSettlementTxt: Label 'This will delete all lines on the settlement.\\Do you want to continue?';
        EMInboxFoundErr: Label '%1 %2 cannot be updated as there are one or more unprocessed lines in the %3.\\Please process the related lines in the %3 before making changes to this %1.';
        ExpensesTxt: Label 'Expenses';
        OneOrMoreInboxError: Label 'There are one or more unprocessed entries in the %1.';
        PerDiemsTxt: Label 'Per Diems';
        ProcessInboxAsapTxt: Label '\\You should process these as soon as possible.';
        ProcessSettlement: Label 'The corresponding settlement needs to be processed first. Please check %1 %2-%3.';
        ReopenMultiplePendExpUsrQst: Label 'This will reopen %1 settlements.\Reopening a document can discard user''s changes when the Mobile App doesn''t have internet connection.\\Are you sure you want to continue?';
        ReopenMultipleQst: Label 'This will reopen %1 settlements.\Are you sure you want to continue?';
        ReopenSinglePendExpUsrQst: Label 'Reopening a document can discard user''s changes when the Mobile App doesn''t have internet connection.\\Are you sure you want to continue?';
        ReopenSingleQst: Label 'This will reopen this settlement.\Are you sure you want to continue?';
        ReqForPreApproval: Label 'Request for pre-approval';
        SettlementNotFound: Label 'The corresponding settlement was not received yet.';
        SettlementPlural: Label 'Settlements';
        SettlementSingular: Label 'Settlement';
        SettlementStatusNotAllowed: Label 'Status must be Open or Pending Expense User for settlement %1';
        StatusNotAllowed: Label 'Status must be Open or Pending Expense User in %1 %2.';


    procedure AssistEditNoSeries(OldExpHeader: Record "CEM Expense Header"): Boolean
    var
        EMSetup: Record "CEM Expense Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        EMSetup.Get;
        EMSetup.TestField("Settlement Nos.");
        if NoSeriesMgt.SelectSeries(EMSetup."Settlement Nos.", OldExpHeader."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;


    procedure LinesExist(): Boolean
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        if "No." = '' then
            exit;

        Expense.SetCurrentKey("Settlement No.");
        Expense.SetRange("Settlement No.", "No.");
        if not Expense.IsEmpty then
            exit(true);

        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", "No.");
        if not Mileage.IsEmpty then
            exit(true);

        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", "No.");
        if not PerDiem.IsEmpty then
            exit(true);
    end;


    procedure SetSkipSendToExpUser(NewSkipSendToExpUser: Boolean)
    begin
        SkipSendToExpUser := NewSkipSendToExpUser;
    end;


    procedure SendToExpenseUser()
    var
        SendToExpUser: Codeunit "CEM Settlement - Send to User";
    begin
        if SkipSendToExpUser then
            exit;

        if Status = Status::"Pending Expense User" then
            SendToExpUser.Update(Rec);
    end;


    procedure GetOverviewDetails() AddInfo: Text[1024]
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get;

        if "No." <> '' then begin
            if IsPreApprovalRequest then
                exit(ReqForPreApproval + ' - ' + Format("Pre-approval Amount") + ' ' + GeneralLedgerSetup."LCY Code");

            Expense.SetCurrentKey("Settlement No.");
            Expense.SetRange("Settlement No.", "No.");
            if Expense.Count = 1 then
                AddTextTo(AddInfo, Format(Expense.Count) + ' ' + Expense.TableCaption)
            else
                if Expense.Count > 1 then
                    AddTextTo(AddInfo, Format(Expense.Count) + ' ' + ExpensesTxt);

            Mileage.SetCurrentKey("Settlement No.");
            Mileage.SetRange("Settlement No.", "No.");
            if Mileage.Count > 0 then
                AddTextTo(AddInfo, Format(Mileage.Count) + ' ' + Mileage.TableCaption);

            PerDiem.SetCurrentKey("Settlement No.");
            PerDiem.SetRange("Settlement No.", "No.");
            if PerDiem.Count = 1 then
                AddTextTo(AddInfo, Format(PerDiem.Count) + ' ' + PerDiem.TableCaption)
            else
                if PerDiem.Count > 1 then
                    AddTextTo(AddInfo, Format(PerDiem.Count) + ' ' + PerDiemsTxt);
        end;
    end;

    local procedure AddTextTo(var ReturnTxt: Text[1024]; TxtToAdd: Text[1024])
    begin
        if TxtToAdd = '' then
            exit;

        if (StrLen(TxtToAdd) + StrLen(ReturnTxt)) > MaxStrLen(ReturnTxt) then
            exit;

        if ReturnTxt = '' then
            ReturnTxt := TxtToAdd
        else
            ReturnTxt := ReturnTxt + ', ' + TxtToAdd;
    end;


    procedure LookupDimensions()
    begin
        DrillDownDimensions(PAGE::"CEM Dimensions");
    end;


    procedure LookupExtraFields()
    begin
        DrillDownDimensions(PAGE::"CEM Extra Fields");
    end;

    local procedure DrillDownDimensions(FormID: Integer)
    var
        EMDim: Record "CEM Dimension";
        TempEMDim: Record "CEM Dimension" temporary;
        ExpDim: Page "CEM Dimensions";
        ExpExtraFields: Page "CEM Extra Fields";
    begin
        EMDim.SetRange("Table ID", DATABASE::"CEM Expense Header");
        EMDim.SetRange("Document Type", "Document Type");
        EMDim.SetRange("Document No.", "No.");
        EMDim.SetRange("Doc. Ref. No.", 0);

        if (not Posted) and StatusOrUserAllowsChange then begin
            if EMDim.FindSet then
                repeat
                    TempEMDim := EMDim;
                    TempEMDim.Insert;
                until EMDim.Next = 0;

            TempEMDim.SetRange("Table ID", DATABASE::"CEM Expense Header");
            TempEMDim.SetRange("Document Type", "Document Type");
            TempEMDim.SetRange("Document No.", "No.");
            TempEMDim.SetRange("Doc. Ref. No.", 0);
            PAGE.RunModal(FormID, TempEMDim);

            if EMDim.EMDimUpdated(TempEMDim, DATABASE::"CEM Expense Header", "Document Type", "No.", 0) then begin
                EMDim.DeleteAll(true);

                if TempEMDim.FindSet then
                    repeat
                        EMDim := TempEMDim;
                        EMDim.Insert(true);
                    until TempEMDim.Next = 0;

                Get("Document Type", "No.");
                SendToExpenseUser;

                CODEUNIT.Run(CODEUNIT::"CEM Settlement - Validate", Rec);
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


    procedure AddDefaultDim(ValidatedFieldNo: Integer)
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        EMDimMgt: Codeunit "CEM Dimension Mgt.";
    begin
        DeleteOldDefaultDim;

        if ContiniaUserSetup.Get("Continia User ID") then begin
            if ContiniaUserSetup.GetSalesPurchCode <> '' then
                EMDimMgt.InsertDefaultDimExpHeader(DATABASE::"Salesperson/Purchaser", ContiniaUserSetup.GetSalesPurchCode, Rec);

            if ContiniaUserSetup."Vendor No." <> '' then
                EMDimMgt.InsertDefaultDimExpHeader(DATABASE::Vendor, ContiniaUserSetup."Vendor No.", Rec);

            if ContiniaUserSetup."Employee No." <> '' then;
            EMDimMgt.InsertDefaultDimExpHeader(DATABASE::Employee, ContiniaUserSetup."Employee No.", Rec);
        end;

        if "Job No." <> '' then
            EMDimMgt.InsertDefaultDimExpHeader(DATABASE::Job, "Job No.", Rec);

        if "Job Task No." <> '' then
            EMDimMgt.InsertDefaultDimExpHeader(DATABASE::"Job Task", "Job Task No.", Rec);

        case ValidatedFieldNo of
            FieldNo("Continia User ID"):
                if ContiniaUserSetup.Get("Continia User ID") then begin
                    if ContiniaUserSetup.GetSalesPurchCode <> '' then
                        EMDimMgt.InsertDefaultDimExpHeader(DATABASE::"Salesperson/Purchaser", ContiniaUserSetup.GetSalesPurchCode, Rec);

                    if ContiniaUserSetup."Vendor No." <> '' then
                        EMDimMgt.InsertDefaultDimExpHeader(DATABASE::Vendor, ContiniaUserSetup."Vendor No.", Rec);

                    if ContiniaUserSetup."Employee No." <> '' then;
                    EMDimMgt.InsertDefaultDimExpHeader(DATABASE::Employee, ContiniaUserSetup."Employee No.", Rec);
                end;

            FieldNo("Job No."):
                if "Job No." <> '' then
                    EMDimMgt.InsertDefaultDimExpHeader(DATABASE::Job, "Job No.", Rec);

            FieldNo("Job Task No."):
                if "Job Task No." <> '' then
                    EMDimMgt.InsertDefaultDimExpHeader(DATABASE::"Job Task", "Job Task No.", Rec);
        end;
    end;

    local procedure DeleteOldDefaultDim()
    var
        ContiniaUser: Record "CDC Continia User Setup";
        EMDimMgt: Codeunit "CEM Dimension Mgt.";
    begin
        if ContiniaUser.Get(xRec."Continia User ID") then begin
            if ContiniaUser.GetSalesPurchCode <> '' then
                EMDimMgt.DeleteDefaultDimExpHeader(DATABASE::"Salesperson/Purchaser", ContiniaUser.GetSalesPurchCode, Rec);

            if ContiniaUser."Vendor No." <> '' then
                EMDimMgt.DeleteDefaultDimExpHeader(DATABASE::Vendor, ContiniaUser."Vendor No.", Rec);

            if ContiniaUser."Employee No." <> '' then;
            EMDimMgt.DeleteDefaultDimExpHeader(DATABASE::Employee, ContiniaUser."Employee No.", Rec);
        end;

        if xRec."Job No." <> '' then
            EMDimMgt.DeleteDefaultDimExpHeader(DATABASE::Job, xRec."Job No.", Rec);

        if xRec."Job Task No." <> '' then
            EMDimMgt.DeleteDefaultDimExpHeader(DATABASE::"Job Task", xRec."Job Task No.", Rec);
    end;


    procedure GetPerDiemTotalLCY(): Decimal
    var
        PerDiem: Record "CEM Per Diem";
        PerDiemLCY: Decimal;
    begin
        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", Rec."No.");
        if PerDiem.FindSet then
            repeat
                PerDiem.CalcFields("Amount (LCY)");
                PerDiemLCY := PerDiemLCY + PerDiem."Amount (LCY)";
            until PerDiem.Next = 0;

        exit(PerDiemLCY);
    end;


    procedure GetAmountLCY(): Decimal
    begin
        CalcFields("Expense Total (LCY)", "Mileage Total (LCY)");
        exit("Expense Total (LCY)" + "Mileage Total (LCY)" + GetPerDiemTotalLCY);
    end;


    procedure GetDataCaption(): Text[250]
    begin
        exit(Format("Document Type") + ' ' + "No.");
    end;


    procedure ExistsInInbox(ShowError: Boolean): Boolean
    var
        ExpHeaderInbox: Record "CEM Expense Header Inbox";
        ExpenseInbox: Record "CEM Expense Inbox";
        MileageInbox: Record "CEM Mileage Inbox";
        PerDiemInbox: Record "CEM Per Diem Inbox";
        EmptyGUID: Guid;
    begin
        if "Exp. Header GUID" = EmptyGUID then
            exit;

        ExpHeaderInbox.SetCurrentKey("Exp. Header GUID");
        ExpHeaderInbox.SetRange("Exp. Header GUID", "Exp. Header GUID");
        ExpHeaderInbox.SetFilter(Status, '%1|%2', ExpHeaderInbox.Status::Pending, ExpHeaderInbox.Status::Error);
        if not ExpHeaderInbox.IsEmpty then
            if ShowError then
                Error(EMInboxFoundErr, TableCaption, "No.", ExpHeaderInbox.GetTableCaption)
            else
                exit(true);

        ExpenseInbox.SetCurrentKey("Expense Header GUID");
        ExpenseInbox.SetRange("Expense Header GUID", "Exp. Header GUID");
        ExpenseInbox.SetFilter(Status, '%1|%2', ExpenseInbox.Status::Pending, ExpenseInbox.Status::Error);
        if not ExpenseInbox.IsEmpty then
            if ShowError then
                Error(EMInboxFoundErr, TableCaption, "No.", ExpenseInbox.TableCaption)
            else
                exit(true);

        MileageInbox.SetCurrentKey("Expense Header GUID");
        MileageInbox.SetRange("Expense Header GUID", "Exp. Header GUID");
        MileageInbox.SetFilter(Status, '%1|%2', MileageInbox.Status::Pending, MileageInbox.Status::Error);
        if not MileageInbox.IsEmpty then
            if ShowError then
                Error(EMInboxFoundErr, TableCaption, "No.", MileageInbox.TableCaption)
            else
                exit(true);

        PerDiemInbox.SetCurrentKey("Settlement GUID");
        PerDiemInbox.SetRange("Settlement GUID", "Exp. Header GUID");
        PerDiemInbox.SetFilter(Status, '%1|%2', PerDiemInbox.Status::Pending, PerDiemInbox.Status::Error);
        if not PerDiemInbox.IsEmpty then
            if ShowError then
                Error(EMInboxFoundErr, TableCaption, "No.", PerDiemInbox.TableCaption)
            else
                exit(true);
    end;


    procedure CheckInboxAndThrowError()
    begin
        if not SuspendInboxCheck then
            ExistsInInbox(true);
    end;


    procedure ThrowInboxError()
    var
        ExpHeaderInbox: Record "CEM Expense Header Inbox";
    begin
        Error(EMInboxFoundErr, TableCaption, "No.", ExpHeaderInbox.GetTableCaption);
    end;


    procedure Navigate()
    var
        NavigateSettlement: Codeunit "CEM Navigate Settlement - Find";
    begin
        NavigateSettlement.NavigateSettlements(Rec);
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
        if Expense.FindSet then
            repeat
                if Expense.HasApprovalComment then
                    exit(true);
            until Expense.Next = 0;

        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", "No.");
        if Mileage.FindSet then
            repeat
                if Mileage.HasApprovalComment then
                    exit(true);
            until Mileage.Next = 0;

        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", "No.");
        if PerDiem.FindSet then
            repeat
                if PerDiem.HasApprovalComment then
                    exit(true);
            until PerDiem.Next = 0;
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
        if Expense.FindSet then
            repeat
                if Expense.HasExpenseComment then
                    exit(true);
            until Expense.Next = 0;

        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", "No.");
        if Mileage.FindSet then
            repeat
                if Mileage.HasMileageComment then
                    exit(true);
            until Mileage.Next = 0;

        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", "No.");
        if PerDiem.FindSet then
            repeat
                if PerDiem.HasPerDiemComment then
                    exit(true);
            until PerDiem.Next = 0;
    end;


    procedure HasErrorComment(ShowFirstError: Boolean; RunValidationChecks: Boolean): Boolean
    var
        EMCmtMgt: Codeunit "CEM Comment Mgt.";
    begin
        exit(EMCmtMgt.HasErrorComments(DATABASE::"CEM Expense Header", "Document Type", "No.", 0, ShowFirstError, RunValidationChecks));
    end;


    procedure HasWarningComment(ShowFirstError: Boolean): Boolean
    var
        EMCmtMgt: Codeunit "CEM Comment Mgt.";
    begin
        exit(EMCmtMgt.HasWarningComments(DATABASE::"CEM Expense Header", "Document Type", "No.", 0, ShowFirstError, true));
    end;


    procedure CheckUnProcessedInbox()
    var
        ExpHeaderInbox: Record "CEM Expense Header Inbox";
        ReleaseNotificationEntry: Record "CEM Release Notification Entry";
        UserDelegation: Record "CEM User Delegation";
        NAVversionMgt: Codeunit "CEM NAV-version Mgt.";
        TextMessage: Text[1024];
    begin
        if UserDelegation.GetDelegationFilter <> '' then
            exit;

        ExpHeaderInbox.SetFilter(Status, '<>%1', ExpHeaderInbox.Status::Accepted);
        if not ExpHeaderInbox.IsEmpty then
            TextMessage := StrSubstNo(OneOrMoreInboxError, ExpHeaderInbox.TableCaption);

        if ReleaseNotificationEntry.CheckForUnprocessedEntries then begin
            if TextMessage <> '' then
                TextMessage := TextMessage + '\\';
            TextMessage := TextMessage + StrSubstNo(OneOrMoreInboxError, ReleaseNotificationEntry.TableCaption);
        end;

        if ReleaseNotificationEntry.CheckForUnprocessedHistEntries then
            NAVversionMgt.SendHistoryToCO(false);

        if TextMessage <> '' then
            Message(TextMessage + ProcessInboxAsapTxt);
    end;


    procedure UpdatePostingDate(PostingDatePolicy: Option FirstDate,LastDate)
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
        NewPostingDate: Date;
    begin
        NewPostingDate := "Posting Date";

        Expense.SetCurrentKey("Settlement No.");
        Expense.SetRange("Settlement No.", "No.");
        if Expense.FindFirst then
            repeat
                CalcPostingDateBasedOnPolicy(PostingDatePolicy, Expense."Document Date", NewPostingDate);
            until Expense.Next = 0;

        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", "No.");
        if Mileage.FindFirst then
            repeat
                CalcPostingDateBasedOnPolicy(PostingDatePolicy, Mileage."Registration Date", NewPostingDate);
            until Mileage.Next = 0;

        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", "No.");
        if PerDiem.FindFirst then
            repeat
                CalcPostingDateBasedOnPolicy(PostingDatePolicy, PerDiem."Posting Date", NewPostingDate);
            until PerDiem.Next = 0;

        if "Posting Date" <> NewPostingDate then begin
            "Posting Date" := NewPostingDate;
            Modify;
        end;
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
    var
        Expense: Record "CEM Expense";
        Expense2: Record "CEM Expense";
        ExpenseForm: Page "CEM Expenses";
    begin
        TestStatusAllowsChange;

        Expense.SetCurrentKey(Posted, "Continia User ID", Status, "Document Date");
        Expense.FilterGroup(4);
        Expense.SetRange("Continia User ID", "Continia User ID");
        Expense.SetRange(Posted, false);
        Expense.SetRange("Settlement No.", '');
        Expense.FilterGroup(0);

        ExpenseForm.LookupMode := true;
        ExpenseForm.SetTableView(Expense);
        if ExpenseForm.RunModal = ACTION::LookupOK then begin
            ExpenseForm.GetSelectionFilter(Expense);

            if Expense.FindSet then
                repeat
                    Expense.TestStatusAllowsChange;
                    Expense2.Get(Expense."Entry No.");

                    if (Status = Status::Open) and
                       (Expense2.Status = Expense2.Status::"Pending Expense User")
                    then
                        CODEUNIT.Run(CODEUNIT::"CEM Expense - Reopen", Expense2);

                    Expense2.Get(Expense."Entry No.");
                    Expense2.Validate("Settlement No.", "No.");
                    Expense2.Modify(true);
                until Expense.Next = 0;
        end;
    end;


    procedure AttachMileageToSettlement()
    var
        Mileage: Record "CEM Mileage";
        Mileage2: Record "CEM Mileage";
        MileageForm: Page "CEM Mileage";
    begin
        TestStatusAllowsChange;

        Mileage.SetCurrentKey(Posted, "Continia User ID", Status, "Registration Date");
        Mileage.FilterGroup(4);
        Mileage.SetRange("Continia User ID", "Continia User ID");
        Mileage.SetRange(Posted, false);
        Mileage.SetRange("Settlement No.", '');
        Mileage.FilterGroup(0);

        MileageForm.LookupMode := true;
        MileageForm.SetTableView(Mileage);
        if MileageForm.RunModal = ACTION::LookupOK then begin
            MileageForm.GetSelectionFilter(Mileage);

            if Mileage.FindSet then
                repeat
                    Mileage.TestStatusAllowsChange;
                    Mileage2.Get(Mileage."Entry No.");

                    if (Status = Status::Open) and
                       (Mileage2.Status = Mileage2.Status::"Pending Expense User")
                    then
                        CODEUNIT.Run(CODEUNIT::"CEM Mileage - Reopen", Mileage2);

                    Mileage2.Validate("Settlement No.", "No.");
                    Mileage2.Modify(true);
                until Mileage.Next = 0;
        end;
    end;


    procedure AttachPerDiemToSettlement()
    var
        PerDiem: Record "CEM Per Diem";
        PerDiem2: Record "CEM Per Diem";
        PerDiemsPage: Page "CEM Per Diems";
    begin
        TestStatusAllowsChange;

        PerDiem.SetCurrentKey(Posted, "Continia User ID", Status);
        PerDiem.FilterGroup(4);
        PerDiem.SetRange("Continia User ID", "Continia User ID");
        PerDiem.SetRange(Posted, false);
        PerDiem.SetRange("Settlement No.", '');
        PerDiem.FilterGroup(0);

        PerDiemsPage.LookupMode := true;
        PerDiemsPage.SetTableView(PerDiem);
        if PerDiemsPage.RunModal = ACTION::LookupOK then begin
            PerDiemsPage.GetSelectionFilter(PerDiem);

            if PerDiem.FindSet then
                repeat
                    PerDiem.TestStatusAllowsChange;
                    PerDiem2.Get(PerDiem."Entry No.");

                    if (Status = Status::Open) and
                       (PerDiem2.Status = PerDiem2.Status::"Pending Expense User")
                    then
                        CODEUNIT.Run(CODEUNIT::"CEM Per Diem - Reopen", PerDiem2);

                    PerDiem2.Validate("Settlement No.", "No.");
                    PerDiem2.Modify(true);
                until PerDiem.Next = 0;
        end;
    end;


    procedure SetHideUI()
    begin
        HideUI := true;
    end;


    procedure NextReminderDate(): Date
    var
        EMReminder: Record "CEM Reminder";
    begin
        exit(
          EMReminder.NextReminderDate(
            "Continia User ID", DATABASE::"CEM Expense Header", "Document Type"::Settlement, "No.", 0, FirstDocumentDate));
    end;


    procedure SetSuspendInboxCheck(NewSuspend: Boolean)
    begin
        SuspendInboxCheck := NewSuspend;
    end;

    local procedure CheckLinesExist()
    begin
        if LinesExist then
            Error(CannotModifyField, FieldCaption("Continia User ID"));
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
        if Expense.FindSet then
            repeat
                DocEarliestDate := Expense.GetEarliestDate;
                if (DocEarliestDate <> 0D) and (DocEarliestDate < FirstDate) then
                    FirstDate := DocEarliestDate;
            until Expense.Next = 0;

        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", "No.");
        if Mileage.FindSet then
            repeat
                DocEarliestDate := Mileage.GetEarliestDate;
                if (DocEarliestDate <> 0D) and (DocEarliestDate < FirstDate) then
                    FirstDate := DocEarliestDate;
            until Mileage.Next = 0;

        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", "No.");
        if PerDiem.FindSet then
            repeat
                DocEarliestDate := PerDiem.GetEarliestDate;
                if (DocEarliestDate <> 0D) and (DocEarliestDate < FirstDate) then
                    FirstDate := DocEarliestDate;
            until PerDiem.Next = 0;
    end;


    procedure GetTableCaptionSingular(): Text[250]
    begin
        exit(SettlementPlural);
    end;


    procedure GetTableCaptionPlural(): Text[250]
    begin
        exit(SettlementPlural);
    end;


    procedure AllocationExists(): Boolean
    var
        Expense: Record "CEM Expense";
        PerDiem: Record "CEM Per Diem";
    begin
        Expense.SetRange("Settlement No.", "No.");
        if Expense.FindSet then
            repeat
                if Expense.AllocationExists then
                    exit(true);
            until Expense.Next = 0;

        PerDiem.SetRange("Settlement No.", "No.");
        if not PerDiem.IsEmpty then
            exit(true);
    end;

    local procedure CheckDates()
    begin
        if ("Departure Date/Time" <> 0DT) and ("Return Date/Time" <> 0DT) then
            if "Departure Date/Time" > "Return Date/Time" then
                Error(DateErr, FieldCaption("Departure Date/Time"), FieldCaption("Return Date/Time"));
    end;


    procedure GetSettlementReadyToAppend(SettlementGUID: Guid; var ExpHeader: Record "CEM Expense Header")
    var
        ExpHeaderInbox: Record "CEM Expense Header Inbox";
    begin
        ExpHeader.SetCurrentKey("Exp. Header GUID");
        ExpHeader.SetRange("Exp. Header GUID", SettlementGUID);
        if not ExpHeader.FindFirst then begin
            ExpHeaderInbox.SetCurrentKey("Exp. Header GUID");
            ExpHeaderInbox.SetRange("Exp. Header GUID", SettlementGUID);
            ExpHeaderInbox.SetFilter(Status, '%1|%2', ExpHeaderInbox.Status::Error, ExpHeaderInbox.Status::Pending);
            if ExpHeaderInbox.FindFirst then
                Error(ProcessSettlement, ExpHeaderInbox.TableCaption, ExpHeaderInbox.FieldCaption("Entry No."), ExpHeaderInbox."Entry No.")
            else
                Error(SettlementNotFound);
        end else
            ExpHeader.TestStatusAllowsChange;
    end;


    procedure EmployeeReimbExpectedInBC(): Boolean
    var
        Expense: Record "CEM Expense";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
    begin
        Expense.SetCurrentKey("Settlement No.");
        Expense.SetRange("Settlement No.", "No.");
        if Expense.FindSet then
            repeat
                if Expense.EmployeeReimbExpectedInBC then
                    exit(true);
            until Expense.Next = 0;

        Mileage.SetCurrentKey("Settlement No.");
        Mileage.SetRange("Settlement No.", "No.");
        if Mileage.FindSet then
            repeat
                if Mileage.EmployeeReimbExpectedInBC then
                    exit(true);
            until Mileage.Next = 0;

        PerDiem.SetCurrentKey("Settlement No.");
        PerDiem.SetRange("Settlement No.", "No.");
        if PerDiem.FindSet then
            repeat
                if PerDiem.EmployeeReimbExpectedInBC then
                    exit(true);
            until PerDiem.Next = 0;
    end;


    procedure IsPreApprovalRequest(): Boolean
    begin
        exit((not LinesExist) and ("Pre-approval Status" = "Pre-approval Status"::Pending));
    end;


    procedure IsPreApproved(): Boolean
    begin
        exit("Pre-approval Status" = "Pre-approval Status"::Approved);
    end;


    procedure IsAmountWithinPreApproval(): Boolean
    begin
        if ("Pre-approval Status" = "Pre-approval Status"::Approved) and ("Pre-approval Amount" > 0) then
            exit(GetAmountLCY <= "Pre-approval Amount");
    end;


    procedure GetEmployeeEmailDep(): Text[250]
    begin
    end;


    procedure ReopenSettlements(var Settlement: Record "CEM Expense Header")
    var
        Settlement2: Record "CEM Expense Header";
        PendingExpUserFound: Boolean;
        Question: Text[1024];
    begin
        // Do we have pending expense user records?
        Settlement.SetRange(Status, Settlement.Status::"Pending Expense User");
        PendingExpUserFound := not Settlement.IsEmpty;
        Settlement.SetRange(Status);

        if Settlement.Count = 1 then begin
            if PendingExpUserFound then
                Question := ReopenSinglePendExpUsrQst
            else
                Question := ReopenSingleQst;
        end else
            if PendingExpUserFound then
                Question := StrSubstNo(ReopenMultiplePendExpUsrQst, Settlement.Count)
            else
                Question := StrSubstNo(ReopenMultipleQst, Settlement.Count);

        if not Confirm(Question, true) then
            exit;

        if Settlement.FindSet(true, false) then
            repeat
                Settlement2 := Settlement;
                CODEUNIT.Run(CODEUNIT::"CEM Settlement - Complete", Settlement2);
            until Settlement.Next = 0;
    end;


    procedure TestStatusOpenOrPendingExpUser()
    begin
        TestStatusAllowsChange;
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
            Error(StatusNotAllowed, "Document Type", "No.");
    end;


    procedure TestStatusOrUserAllowsChange()
    begin
        if not StatusOrUserAllowsChange then
            Error(StatusNotAllowed, "Document Type", "No.");
    end;


    procedure NextApprover(): Code[50]
    var
        ApprovalMgt: Codeunit "CEM Approval Management";
    begin
        exit(ApprovalMgt.GetNextApprover(DATABASE::"CEM Expense Header", "No."));
    end;


    procedure CurrentUserIsNextApprover(): Boolean
    begin
        exit(UserId = NextApprover);
    end;


    procedure OpenDocumentCard()
    var
        PostedSettlementCard: Page "CEM Posted Settlement Card";
        SettlementCard: Page "CEM Settlement Card";
    begin
        if Posted then begin
            PostedSettlementCard.SetRecord(Rec);
            PostedSettlementCard.LockToSpecificDocumentNo("No.");
            PostedSettlementCard.Run;
        end else begin
            SettlementCard.SetRecord(Rec);
            SettlementCard.LockToSpecificDocumentNo("No.");
            SettlementCard.Run;
        end
    end;
}

