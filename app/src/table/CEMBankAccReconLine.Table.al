table 6086375 "CEM Bank Acc. Recon. Line"
{
    Caption = 'Bank Account Reconciliation Line';
    PasteIsValid = false;

    fields
    {
        field(1; "Bank Account Type"; Option)
        {
            Caption = 'Bank Account Type';
            OptionCaption = 'G/L Account,,Vendor,Bank Account';
            OptionMembers = "G/L Account",,Vendor,"Bank Account";
        }
        field(2; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
        }
        field(3; "Statement No."; Code[20])
        {
            Caption = 'Statement No.';
        }
        field(4; "Statement Line No."; Integer)
        {
            Caption = 'Statement Line No.';
        }
        field(6; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; "Statement Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Statement Amount';
        }
        field(9; Difference; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Difference';
        }
        field(10; "Applied Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Applied Amount';
            Editable = false;
        }
        field(11; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Bank Transaction Entry,Difference';
            OptionMembers = "Bank Transaction Entry",Difference;
        }
        field(12; "Applied Entries"; Integer)
        {
            Caption = 'Applied Entries';
            Editable = false;
        }
        field(13; "Value Date"; Date)
        {
            Caption = 'Value Date';
        }
        field(17; "Additional Transaction Info"; Text[100])
        {
            Caption = 'Additional Transaction Info';
        }
        field(27; "Bank Transaction Entry No."; Integer)
        {
            Caption = 'Bank Transaction Entry No.';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Bank Account Type", "Bank Account No.", "Statement No.", "Statement Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
            SumIndexFields = "Statement Amount", Difference;
        }
    }
    procedure DisplayApplication()
    begin
    end;

    procedure GetCurrencyCode(): Code[10]
    begin
    end;

    procedure FilterBankRecLines(BankAccRecon: Record "CEM Bank Acc. Reconciliation")
    begin
    end;

    procedure GetStyle(): Text[20]
    begin
    end;

    procedure LinesExist(BankAccRecon: Record "CEM Bank Acc. Reconciliation"): Boolean
    begin
    end;

    procedure ShowStatementTransaction()
    begin
    end;
}