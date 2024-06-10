table 6086376 "CEM Bank Account Statement"
{
    Caption = 'Bank Account Statement';
    DataCaptionFields = "Bank Account No.", "Statement No.";
    LookupPageID = "CEM Bank Acc. StatementList";

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
            TableRelation = IF ("Bank Account Type" = CONST ("G/L Account")) "G/L Account"
            ELSE
            IF ("Bank Account Type" = CONST ("Bank Account")) "Bank Account"
            ELSE
            IF ("Bank Account Type" = CONST (Vendor)) Vendor;
        }
        field(3; "Statement No."; Code[20])
        {
            Caption = 'Statement No.';
            NotBlank = true;
        }
        field(4; "Statement Ending Balance"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Statement Ending Balance';
        }
        field(5; "Statement Date"; Date)
        {
            Caption = 'Statement Date';
        }
        field(6; "Balance Last Statement"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
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

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        EMBankAccStmtLine.SetRange("Bank Account Type", "Bank Account Type");
        EMBankAccStmtLine.SetRange("Bank Account No.", "Bank Account No.");
        EMBankAccStmtLine.SetRange("Statement No.", "Statement No.");
        EMBankAccStmtLine.DeleteAll;
    end;

    trigger OnRename()
    begin
        Error(Text000, TableCaption);
    end;

    var
        EMBankAccStmtLine: Record "CEM Bank Acc. Statement Line";
        Text000: Label 'You cannot rename a %1.';

    local procedure GetCurrencyCode(): Code[10]
    var
        ContiniaUserCreditCard: Record "CEM Continia User Credit Card";
    begin
        ContiniaUserCreditCard.GetAccountCurrencyCode("Bank Account Type", "Bank Account No.");
    end;
}

