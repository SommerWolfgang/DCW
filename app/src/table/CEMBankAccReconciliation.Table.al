table 6086374 "CEM Bank Acc. Reconciliation"
{
    Caption = 'Bank Account Reconciliation';
    DataCaptionFields = "Bank Account No.", "Statement No.";

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
            NotBlank = true;
        }
        field(3; "Statement No."; Code[20])
        {
            Caption = 'Statement No.';
            NotBlank = true;
        }
        field(4; "Statement Ending Balance"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Statement Ending Balance';
        }
        field(5; "Statement Date"; Date)
        {
            Caption = 'Statement Date';
        }
        field(6; "Balance Last Statement"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Balance Last Statement';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Bank Account Type", "Bank Account No.", "Statement No.")
        {
            Clustered = true;
        }
    }
    procedure GetBalanceLastStatement(): Decimal
    begin
    end;

    procedure MatchSingle(DateRange: Integer; ExpType: Code[20])
    begin
    end;
}