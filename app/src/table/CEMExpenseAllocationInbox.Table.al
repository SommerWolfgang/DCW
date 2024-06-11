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

    procedure InitFromExpInbox(var ExpAllInbox: Record "CEM Expense Allocation Inbox"; ExpInbox: Record "CEM Expense Inbox")
    begin
    end;

    procedure DrillDownAttendees()
    begin
    end;

    procedure GetAttendeesForDisplay() DisplayTxt: Text[150]
    begin
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

