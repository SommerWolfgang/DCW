table 6086322 "CEM Expense Allocation Inbox"
{
    Caption = 'Expense Allocation Inbox';
    DataCaptionFields = "Entry No.", "Continia User ID", Description;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(3; "Inbox Entry No."; Integer)
        {
            Caption = 'Inbox Entry No.';
        }
        field(10; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup";

            trigger OnValidate()
            begin
                Error(NotAllowed, FieldCaption("Continia User ID"));
            end;
        }
        field(11; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(13; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(14; "Date Created"; Date)
        {
            Caption = 'Date Created';
        }
        field(15; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            NotBlank = true;
            TableRelation = "CEM Country/Region";

            trigger OnValidate()
            begin
                Validate("Expense Type");
            end;
        }
        field(16; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(17; "No Refund"; Boolean)
        {
            Caption = 'No Refund';
        }
        field(18; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate()
            begin
                UpdateAmount(FieldNo(Amount));
            end;
        }
        field(19; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            var
                GLSetup: Record "General Ledger Setup";
                SplitAndAllocationMgt: Codeunit "CEM Split and Allocation Mgt.";
            begin
                GLSetup.Get;
                if GLSetup."Global Dimension 1 Code" <> '' then
                    SplitAndAllocationMgt.UpdateExpInboxAllocDim(
                      DATABASE::"CEM Expense Allocation Inbox", "Entry No.", GLSetup."Global Dimension 1 Code", "Global Dimension 1 Code", '', '');
            end;
        }
        field(20; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            var
                GLSetup: Record "General Ledger Setup";
                SplitAndAllocationMgt: Codeunit "CEM Split and Allocation Mgt.";
            begin
                GLSetup.Get;
                if GLSetup."Global Dimension 2 Code" <> '' then
                    SplitAndAllocationMgt.UpdateExpInboxAllocDim(
                      DATABASE::"CEM Expense Allocation Inbox", "Entry No.", GLSetup."Global Dimension 2 Code", "Global Dimension 2 Code", '', '');
            end;
        }
        field(21; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(22; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(23; Billable; Boolean)
        {
            Caption = 'Billable';

            trigger OnValidate()
            begin
                if Billable then
                    "Job Line Type" := "Job Line Type"::Contract
                else
                    "Job Line Type" := "Job Line Type"::" ";
            end;
        }
        field(24; "Job Line Type"; Option)
        {
            Caption = 'Job Line Type';
            OptionCaption = ' ,Budget,Billable,Both Budget and Billable';
            OptionMembers = " ",Schedule,Contract,"Both Schedule and Contract";
        }
        field(25; "Cash/Private Card"; Boolean)
        {
            Caption = 'Cash/Private Card';
            Editable = false;
        }
        field(26; "Expense Type"; Code[20])
        {
            Caption = 'Expense Type';
            TableRelation = "CEM Expense Type";
        }
        field(27; Modified; Boolean)
        {
            Caption = 'Modified';
        }
        field(28; "Amount %"; Decimal)
        {
            Caption = 'Amount %';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                UpdateAmount(FieldNo("Amount %"));
            end;
        }
        field(29; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
        field(30; "Amount w/o VAT"; Decimal)
        {
            Caption = 'Amount without VAT';

            trigger OnValidate()
            begin
                "VAT Amount" := Amount - "Amount w/o VAT";
            end;
        }
        field(31; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';

            trigger OnValidate()
            begin
                "Amount w/o VAT" := Amount - "VAT Amount";
            end;
        }
        field(32; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(112; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(113; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Table ID", "Inbox Entry No.")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Inbox Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        EMAttendeeInbox: Record "CEM Attendee Inbox";
        EMDimInbox: Record "CEM Dimension Inbox";
    begin
        EMDimInbox.SetRange("Table ID", DATABASE::"CEM Expense Allocation Inbox");
        EMDimInbox.SetRange("Document Type", 0);
        EMDimInbox.SetRange("Document No.", '');
        EMDimInbox.SetRange("Doc. Ref. No.", "Entry No.");
        EMDimInbox.DeleteAll;

        EMAttendeeInbox.SetRange("Table ID", DATABASE::"CEM Expense Allocation");
        EMAttendeeInbox.SetRange("Doc. Ref. No.", "Entry No.");
        EMAttendeeInbox.DeleteAll;
    end;

    trigger OnInsert()
    var
        ExpenseInbox: Record "CEM Expense Inbox";
        SplitAndAllocationMgt: Codeunit "CEM Split and Allocation Mgt.";
    begin
        ExpenseInbox.Get("Inbox Entry No.");
        SplitAndAllocationMgt.CopyExpInboxDimToAllocationDim(ExpenseInbox, Rec);

        if not ("Amount %" in [0, 100]) then
            Modified := true;
    end;

    trigger OnModify()
    begin
        Modified := true;
    end;

    var
        ConfRemAmount: Label 'The amount on the expense (%1 %2) and the total allocated amount (%1 %3) do not match. Do you want to close the page anyway?';
        ConfZeroLines: Label 'Allocations with 0 amount exist. Are you sure you want to keep these?';
        NotAllowed: Label 'You are not allowed to change %1.';
        RemAmountMissmatchErr: Label 'The amount on the expense (%1 %2) and the total allocated amount (%1 %3) do not match.';
        Text002: Label 'The %1 must be inserted before you can show dimensions.';
        ZeroLinesErr: Label 'Allocations with amount 0 are not allowed.';


    procedure GetLastEntryNo(): Integer
    var
        ExpAllocInbox: Record "CEM Expense Allocation Inbox";
    begin
        if ExpAllocInbox.FindLast then
            exit(ExpAllocInbox."Entry No.")
        else
            exit(1);
    end;

    local procedure UpdateAmount(CalledByFieldNo: Integer)
    var
        ExpInbox: Record "CEM Expense Inbox";
        Currency: Record Currency;
    begin
        ExpInbox.Get("Inbox Entry No.");
        Currency.InitRoundingPrecision;

        case CalledByFieldNo of

            FieldNo(Amount):
                if ExpInbox.Amount = 0 then
                    "Amount %" := 100
                else
                    "Amount %" := Amount / ExpInbox.Amount * 100;

            FieldNo("Amount %"):
                Amount := Round("Amount %" / 100 * ExpInbox.Amount, Currency."Amount Rounding Precision");
        end;

        "VAT Amount" := Round("Amount %" / 100 * ExpInbox."VAT Amount");
        "Amount w/o VAT" := "Amount w/o VAT" - "VAT Amount";
    end;


    procedure ShowDimensions(ReadOnly: Boolean)
    var
        ExpInbox: Record "CEM Expense Inbox";
    begin
        if "Entry No." = 0 then
            Error(Text002, TableCaption);

        ExpInbox.Get("Inbox Entry No.");
        DrillDownDimensions(not ReadOnly);
    end;

    local procedure DrillDownDimensions(Editable: Boolean)
    var
        EMDimInbox: Record "CEM Dimension Inbox";
        TempEMDimInbox: Record "CEM Dimension Inbox" temporary;
        ExpInbox: Record "CEM Expense Inbox";
        ExpInboxDim: Page "CEM Inbox Dimension";
    begin
        EMDimInbox.SetRange("Table ID", DATABASE::"CEM Expense Allocation Inbox");
        EMDimInbox.SetRange("Document Type", 0);
        EMDimInbox.SetRange("Document No.", '');
        EMDimInbox.SetRange("Doc. Ref. No.", "Entry No.");

        ExpInbox.Get("Inbox Entry No.");

        TempEMDimInbox.DeleteAll;
        if (not (ExpInbox.Status = ExpInbox.Status::Accepted)) and Editable then begin
            if EMDimInbox.FindSet then
                repeat
                    TempEMDimInbox := EMDimInbox;
                    TempEMDimInbox.Insert;
                until EMDimInbox.Next = 0;

            TempEMDimInbox.SetRange("Table ID", DATABASE::"CEM Expense Allocation Inbox");
            TempEMDimInbox.SetRange("Document Type", 0);
            TempEMDimInbox.SetRange("Document No.", '');
            TempEMDimInbox.SetRange("Doc. Ref. No.", "Entry No.");
            PAGE.RunModal(PAGE::"CEM Inbox Dimension", TempEMDimInbox);

            if EMDimInbox.EMDimInboxUpdated(TempEMDimInbox, DATABASE::"CEM Expense Allocation Inbox", 0, '', "Entry No.") then begin
                EMDimInbox.DeleteAll(true);

                if TempEMDimInbox.FindSet then
                    repeat
                        EMDimInbox := TempEMDimInbox;
                        EMDimInbox.Insert(true);
                    until TempEMDimInbox.Next = 0;
            end;
        end else begin
            ExpInboxDim.SetTableView(EMDimInbox);
            ExpInboxDim.Editable := false;
            ExpInboxDim.RunModal;
        end;
    end;


    procedure InitFromExpInbox(var ExpAllInbox: Record "CEM Expense Allocation Inbox"; ExpInbox: Record "CEM Expense Inbox")
    begin
        ExpAllInbox."Entry No." := GetLastEntryNo + 1;
        ExpAllInbox."Table ID" := DATABASE::"CEM Expense Inbox";
        ExpAllInbox."Inbox Entry No." := ExpInbox."Entry No.";
        ExpAllInbox."Continia User ID" := ExpInbox."Continia User ID";
        ExpAllInbox."Document Date" := ExpInbox."Document Date";
        ExpAllInbox."Date Created" := Today;
        ExpAllInbox."Cash/Private Card" := ExpInbox."Cash/Private Card";
        ExpAllInbox.Description := ExpInbox.Description;
        ExpAllInbox."Description 2" := ExpInbox."Description 2";
        ExpAllInbox."Country/Region Code" := ExpInbox."Country/Region Code";
        ExpAllInbox."Document Date" := ExpInbox."Document Date";
        ExpAllInbox."Currency Code" := ExpInbox."Currency Code";
        ExpAllInbox.Amount := Amount;
        ExpAllInbox."Expense Type" := ExpInbox."Expense Type";
        ExpAllInbox."Global Dimension 1 Code" := ExpInbox."Global Dimension 1 Code";
        ExpAllInbox."Global Dimension 2 Code" := ExpInbox."Global Dimension 2 Code";
        ExpAllInbox."Job No." := ExpInbox."Job No.";
        ExpAllInbox."Job Task No." := ExpInbox."Job Task No.";
        ExpAllInbox.Billable := ExpInbox.Billable;
    end;


    procedure DrillDownAttendees()
    var
        ExpAttendeeInbox: Record "CEM Attendee Inbox";
        ExpInbox: Record "CEM Expense Inbox";
        ExpAttendeesInbox: Page "CEM Expense Attendees Inbox";
    begin
        if ExpInbox.Get("Inbox Entry No.") then begin
            ExpAttendeeInbox.SetRange("Table ID", DATABASE::"CEM Expense Allocation Inbox");
            ExpAttendeeInbox.SetRange("Doc. Ref. No.", "Entry No.");
            ExpAttendeesInbox.SetTableView(ExpAttendeeInbox);
            ExpAttendeesInbox.Editable := not (ExpInbox.Status = ExpInbox.Status::Accepted);
            ExpAttendeesInbox.RunModal;
        end;
    end;


    procedure GetAttendeesForDisplay() DisplayTxt: Text[150]
    var
        ExpAttendeeInbox: Record "CEM Attendee Inbox";
    begin
        exit(ExpAttendeeInbox.GetAttendeesForDisplay(DATABASE::"CEM Expense Allocation Inbox", "Entry No."));
    end;


    procedure ValidateAllocationConsistency(ShowDialog: Boolean): Boolean
    var
        ExpenseAllocationInbox: Record "CEM Expense Allocation Inbox";
        ExpenseInbox: Record "CEM Expense Inbox";
    begin
        ExpenseInbox.Get(Rec."Inbox Entry No.");

        ExpenseAllocationInbox.SetCurrentKey("Table ID", "Inbox Entry No.");
        ExpenseAllocationInbox.SetRange("Table ID", DATABASE::"CEM Expense Inbox");
        ExpenseAllocationInbox.SetRange("Inbox Entry No.", Rec."Inbox Entry No.");
        ExpenseAllocationInbox.CalcSums(Amount);
        if (not ExpenseAllocationInbox.IsEmpty) and (ExpenseAllocationInbox.Amount <> ExpenseInbox.Amount) then
            if ShowDialog then
                exit(
                  Confirm(
                    ConfRemAmount, false, ExpenseInbox."Currency Code", ExpenseInbox.Amount, ExpenseInbox.Amount - ExpenseAllocationInbox.Amount))
            else
                Error(
                  RemAmountMissmatchErr, ExpenseInbox."Currency Code", ExpenseInbox.Amount, ExpenseInbox.Amount - ExpenseAllocationInbox.Amount);

        if ZeroAmountLines then
            if ShowDialog then
                exit(Confirm(ConfZeroLines, false))
            else
                Error(ZeroLinesErr);

        exit(true);
    end;

    local procedure ZeroAmountLines(): Boolean
    var
        ExpAllocInbox: Record "CEM Expense Allocation Inbox";
    begin
        ExpAllocInbox.SetCurrentKey("Table ID", "Inbox Entry No.");
        ExpAllocInbox.SetRange("Table ID", DATABASE::"CEM Expense Inbox");
        ExpAllocInbox.SetRange("Inbox Entry No.", "Inbox Entry No.");
        ExpAllocInbox.SetRange(Amount, 0);
        exit(not ExpAllocInbox.IsEmpty);
    end;


    procedure DeleteAutoGeneratedEntries()
    var
        ExpAllocInbox: Record "CEM Expense Allocation Inbox";
    begin
        ExpAllocInbox.SetCurrentKey("Table ID", "Inbox Entry No.");
        ExpAllocInbox.SetRange("Table ID", DATABASE::"CEM Expense Inbox");
        ExpAllocInbox.SetRange("Inbox Entry No.", "Inbox Entry No.");
        ExpAllocInbox.SetRange(Modified, false);
        ExpAllocInbox.DeleteAll(true);
    end;
}

