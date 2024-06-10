table 6086374 "CEM Bank Acc. Reconciliation"
{
    Caption = 'Bank Account Reconciliation';
    DataCaptionFields = "Bank Account No.", "Statement No.";
    LookupPageID = "CEM Bank Acc. Recon. List";

    fields
    {
        field(1; "Bank Account Type"; Option)
        {
            Caption = 'Bank Account Type';
            OptionCaption = 'G/L Account,,Vendor,Bank Account';
            OptionMembers = "G/L Account",,Vendor,"Bank Account";

            trigger OnValidate()
            begin
                if "Bank Account Type" <> xRec."Bank Account Type" then
                    Validate("Bank Account No.", '');
            end;
        }
        field(2; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            NotBlank = true;
            TableRelation = IF ("Bank Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bank Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bank Account Type" = CONST(Vendor)) Vendor;

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
            begin
                ValidateAccount;

                if Rec."Statement No." = '' then begin
                    EMSetup.LockTable;
                    EMSetup.Get;
                    if EMSetup."Last Statement No." <> '' then
                        "Statement No." := IncStr(EMSetup."Last Statement No.")
                    else
                        "Statement No." := Format(1);
                    EMSetup."Last Statement No." := "Statement No.";
                    EMSetup.Modify;
                end;

                "Balance Last Statement" := GetBalanceLastStatement;
            end;
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
        EMBankAccReconLine.Reset;
        EMBankAccReconLine.SetRange("Bank Account Type", "Bank Account Type");
        EMBankAccReconLine.SetRange("Bank Account No.", "Bank Account No.");
        EMBankAccReconLine.SetRange("Statement No.", "Statement No.");
        EMBankAccReconLine.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        EMPostedBankAccStmt: Record "CEM Bank Account Statement";
    begin
        TestField("Bank Account No.");
        TestField("Statement No.");

        if EMPostedBankAccStmt.Get("Bank Account Type", "Bank Account No.", "Statement No.") then
            Error(Text000, "Statement No.");
    end;

    trigger OnRename()
    var
        ReconLine: Record "CEM Bank Acc. Recon. Line";
    begin
        ReconLine.SetRange("Bank Account Type", xRec."Bank Account Type");
        ReconLine.SetRange("Bank Account No.", xRec."Bank Account No.");
        ReconLine.SetRange("Statement No.", xRec."Statement No.");
        if not ReconLine.IsEmpty then
            Error(Text001, TableCaption);
    end;

    var
        EMBankAccReconLine: Record "CEM Bank Acc. Recon. Line";
        Text000: Label 'Statement %1 already exists.';
        Text001: Label 'You cannot rename a %1.';

    local procedure GetCurrencyCode(): Code[10]
    var
        ContiniaUserCreditCard: Record "CEM Continia User Credit Card";
    begin
        ContiniaUserCreditCard.GetAccountCurrencyCode("Bank Account Type", "Bank Account No.");
    end;

    local procedure ValidateAccount()
    var
        ContiniaUserCreditCard: Record "CEM Continia User Credit Card";
    begin
        ContiniaUserCreditCard.CheckAccount("Bank Account Type", "Bank Account No.");
    end;


    procedure GetBalanceLastStatement(): Decimal
    var
        EMBankAccStatement: Record "CEM Bank Account Statement";
    begin
        EMBankAccStatement.SetRange("Bank Account Type", "Bank Account Type");
        EMBankAccStatement.SetRange("Bank Account No.", "Bank Account No.");
        if EMBankAccStatement.FindLast then
            exit(EMBankAccStatement."Statement Ending Balance");
    end;


    procedure MatchSingle(DateRange: Integer; ExpType: Code[20])
    var
        MatchBankRecLines: Codeunit "CEM Match Bank Rec. Lines";
    begin
        MatchBankRecLines.MatchSingle(Rec, DateRange, ExpType);
    end;
}

