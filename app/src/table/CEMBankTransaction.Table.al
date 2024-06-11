table 6086330 "CEM Bank Transaction"
{
    Caption = 'Bank Transaction';
    DataCaptionFields = "Entry No.", "Card No.", "Card Name";
    Permissions = TableData "CEM Continia User Credit Card" = r;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            NotBlank = true;
        }
        field(2; "Card No."; Code[20])
        {
            Caption = 'Card No.';
        }
        field(3; "Card Name"; Text[50])
        {
            Caption = 'Card Name';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(7; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(8; "Currency Exch. Rate"; Decimal)
        {
            Caption = 'Currency Exch. Rate';
            DecimalPlaces = 0 : 15;
        }
        field(9; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';

        }
        field(10; "Bank-Currency Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Bank-Currency Amount';
        }
        field(11; "Entry Type"; Integer)
        {
            Caption = 'Entry Type';
        }
        field(12; "Business Category ID"; Code[50])
        {
            Caption = 'Business Category ID';
        }
        field(13; "Business No."; Code[20])
        {
            Caption = 'Business No.';
        }
        field(14; "Business Name"; Text[250])
        {
            Caption = 'Business Name';
        }
        field(15; "Business Address"; Text[80])
        {
            Caption = 'Business Address';
        }
        field(16; "Business Address 2"; Text[80])
        {
            Caption = 'Business Address 2';
        }
        field(17; "Business Address 3"; Text[80])
        {
            Caption = 'Business Address 3';
        }
        field(18; "Business Country/Region"; Code[20])
        {
            Caption = 'Business Country/Region';
        }
        field(19; "Business Post Code"; Code[20])
        {
            Caption = 'Business Post Code';
        }
        field(20; "Document Time"; Time)
        {
            Caption = 'Document Time';
            Editable = false;
        }
        field(21; "Bank Currency Code"; Code[10])
        {
            Caption = 'Bank Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(22; "Transaction ID"; Text[150])
        {
            Caption = 'Transaction ID';
            Editable = false;
        }
        field(23; "Travel Passenger Name"; Text[50])
        {
            Caption = 'Travel Passenger Name';
        }
        field(24; "Travel Route"; Text[50])
        {
            Caption = 'Travel Route';
        }
        field(25; "Travel Departure Date"; Date)
        {
            Caption = 'Travel Departure Date';
        }
        field(26; "Travel Return Date"; Date)
        {
            Caption = 'Travel Return Date';
        }
        field(27; "Travel Ticket Number"; Text[50])
        {
            Caption = 'Travel Ticket Number';
        }
        field(40; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            TableRelation = "CEM Bank";
        }
        field(41; "Bank Country/Region Code"; Code[10])
        {
            Caption = 'Bank Country/Region Code';
        }
        field(45; "CO Entry No."; Integer)
        {
            Caption = 'Continia Online Entry No.';
        }
        field(50; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
        }
        field(51; "Exclude Entry"; Boolean)
        {
            Caption = 'Exclude Entry';
        }
        field(70; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(71; "Posted Date/Time"; DateTime)
        {
            Caption = 'Posted Date Time';
            Editable = false;
        }
        field(72; "Posted by User ID"; Code[50])
        {
            Caption = 'Posted by User ID';
            Editable = false;
        }
        field(73; "Posted Doc. ID"; Code[20])
        {
            Caption = 'Posted Doc. ID';
            Editable = false;
        }
        field(74; "Bank Statement Transaction"; Boolean)
        {
            Caption = 'Bank Statement Transaction';
        }
        field(77; "Statement Status"; Option)
        {
            Caption = 'Statement Status';
            OptionCaption = 'Open,Bank Transaction Applied,Closed';
            OptionMembers = Open,"Bank Transaction Applied",Closed;
        }
        field(78; "Statement No."; Code[20])
        {
            Caption = 'Statement No.';
            TableRelation = "CEM Bank Acc. Recon. Line"."Statement No.";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(79; "Statement Line No."; Integer)
        {
            Caption = 'Statement Line No.';
            TableRelation = "CEM Bank Acc. Recon. Line"."Statement Line No.";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(80; "Bank Account Type"; Option)
        {
            Caption = 'Bank Account Type';
            OptionCaption = 'G/L Account,,Vendor,Bank Account';
            OptionMembers = "G/L Account",,Vendor,"Bank Account";
        }
        field(81; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            NotBlank = true;
        }
        field(83; Reconciled; Boolean)
        {
            Caption = 'Reconciled';
        }
        field(84; "Reconciled Date/Time"; DateTime)
        {
            Caption = 'Reconciled Date/Time';
            Editable = false;
        }
        field(85; "Reconciled by User ID"; Code[50])
        {
            Caption = 'Reconciled by User ID';
            Editable = false;
        }
        field(86; "Usage Entry No."; Integer)
        {
            Caption = 'Usage Entry No.';
            Editable = false;
        }
        field(100; "Bank Agreement ID"; Text[30])
        {
            Caption = 'Bank Agreement ID';
        }
        field(120; "Employee No."; Text[50])
        {
            Caption = 'Employee No.';
        }
        field(180; "Expense Type"; Code[20])
        {
            Caption = 'Expense Type';
        }
        field(200; "Matched to Expense"; Boolean)
        {
            Caption = 'Matched to Expense';
            Editable = false;
        }
        field(250; Duplicate; Boolean)
        {
            Caption = 'Duplicate';

            trigger OnValidate()
            begin
                TestField(Duplicate, false);
            end;
        }
        field(260; "User Paid Credit Card"; Boolean)
        {
            Caption = 'Private Invoiced';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Continia User ID", "Matched to Expense", "Currency Code", "Exclude Entry")
        {
            SumIndexFields = Amount, "Bank-Currency Amount";
        }
        key(Key3; "Matched to Expense")
        {
        }
        key(Key4; "Card No.", "Posting Date")
        {
        }
        key(Key5; Posted, "Continia User ID", "Matched to Expense")
        {
        }
        key(Key6; "Posted Doc. ID")
        {
        }
        key(Key7; "Transaction ID")
        {
        }
        key(Key8; Posted, "Posted Date/Time", "Entry No.")
        {
        }
        key(Key9; Reconciled, "Bank Statement Transaction")
        {
        }
        key(Key10; "Bank Statement Transaction")
        {
        }
        key(Key11; "Bank Account Type", "Bank Account No.", "Bank Statement Transaction", Reconciled, Posted)
        {
            SumIndexFields = "Bank-Currency Amount";
        }
    }
    procedure CheckUnProcessedBankInbox()
    begin
    end;

    procedure ApplyMappingRule()
    begin
    end;

    procedure MatchAndCreateExpense()
    begin
    end;

    procedure ShowMatchedExpense()
    begin
    end;

    procedure GetBankAccountCurrencyCode(): Code[10]
    begin
    end;

    procedure Navigate()
    begin
    end;

    procedure LookupDimensions()
    begin
    end;

    procedure GetMatchedExpenseEntryNo(): Integer
    begin
    end;

    procedure IsApplied(): Boolean
    begin
    end;

    procedure SetStyle(): Text[1024]
    begin
    end;

    procedure GetExpenseStatus(): Integer
    begin
    end;

    procedure SetUnprocessedFilters()
    begin
    end;

    procedure SetProcessedFilters()
    begin
    end;

    procedure SetExcludedFilters()
    begin
    end;

    procedure GetRecordID(var RecID: RecordID)
    begin
    end;
}