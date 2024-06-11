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
            TableRelation = IF ("Bank Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bank Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bank Account Type" = CONST(Vendor)) Vendor;
        }
        field(3; "Statement No."; Code[20])
        {
            Caption = 'Statement No.';
            TableRelation = "CEM Bank Acc. Reconciliation"."Statement No." WHERE("Bank Account Type" = FIELD("Bank Account Type"),
                                                                                  "Bank Account No." = FIELD("Bank Account No."));
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
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Statement Amount';

            trigger OnValidate()
            begin
                Difference := "Statement Amount" - "Applied Amount";
            end;
        }
        field(9; Difference; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Difference';

            trigger OnValidate()
            begin
                "Statement Amount" := "Applied Amount" + Difference;
            end;
        }
        field(10; "Applied Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Applied Amount';
            Editable = false;

            trigger OnLookup()
            begin
                DisplayApplication;
            end;

            trigger OnValidate()
            begin
                Difference := "Statement Amount" - "Applied Amount";
            end;
        }
        field(11; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Bank Transaction Entry,Difference';
            OptionMembers = "Bank Transaction Entry",Difference;

            trigger OnValidate()
            begin
                if ("Applied Amount" <> xRec."Applied Amount") and
                   (Type <> 0)
                then
                    if Confirm(Text001, false) then begin
                        RemoveApplication;
                        Validate(Difference, 0);
                        Type := 0;
                    end else
                        Error(Text002);
            end;
        }
        field(12; "Applied Entries"; Integer)
        {
            Caption = 'Applied Entries';
            Editable = false;

            trigger OnLookup()
            begin
                DisplayApplication;
            end;
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

            trigger OnLookup()
            begin
                ShowStatementTransaction;
            end;
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

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        RemoveApplication;
    end;

    trigger OnInsert()
    begin
        EMBankAccRecon.Get("Bank Account Type", "Bank Account No.", "Statement No.");
        Type := 0;
        Validate(Difference, 0);
    end;

    trigger OnModify()
    begin
        if Rec."Statement Amount" <> xRec."Statement Amount" then
            RemoveApplication;
    end;

    trigger OnRename()
    begin
        Error(Text000, TableCaption);
    end;

    var
        EMBankAccRecon: Record "CEM Bank Acc. Reconciliation";
        EMBankAccSetStmtNo: Codeunit "CEM Bank Entry Set Recon.-No.";
        Text000: Label 'You cannot rename a %1.';
        Text001: Label 'Delete application?';
        Text002: Label 'Update canceled.';

    local procedure RemoveApplication()
    var
        BankTransaction: Record "CEM Bank Transaction";
    begin
        BankTransaction.SetCurrentKey("Bank Account Type", "Bank Account No.");
        BankTransaction.SetRange("Bank Account Type", "Bank Account Type");
        BankTransaction.SetRange("Bank Account No.", "Bank Account No.");
        BankTransaction.SetRange("Statement Status", BankTransaction."Statement Status"::"Bank Transaction Applied");
        BankTransaction.SetRange("Statement No.", "Statement No.");
        BankTransaction.SetRange("Statement Line No.", "Statement Line No.");
        BankTransaction.SetRange("Bank Statement Transaction", false);
        BankTransaction.LockTable;

        if BankTransaction.FindSet then
            repeat
                EMBankAccSetStmtNo.RemoveReconNo(BankTransaction, Rec);
            until BankTransaction.Next = 0;

        "Applied Entries" := 0;
        Validate("Applied Amount", 0);
        Modify;
    end;


    procedure DisplayApplication()
    var
        BankTransaction: Record "CEM Bank Transaction";
        BankTransactions: Page "CEM Bank Transactions";
    begin
        BankTransaction.SetCurrentKey("Bank Account Type", "Bank Account No.");
        BankTransaction.SetRange("Bank Account Type", "Bank Account Type");
        BankTransaction.SetRange("Bank Account No.", "Bank Account No.");
        BankTransaction.SetRange("Statement Status", BankTransaction."Statement Status"::"Bank Transaction Applied");
        BankTransaction.SetRange("Statement No.", "Statement No.");
        BankTransaction.SetRange("Statement Line No.", "Statement Line No.");
        BankTransaction.SetRange("Bank Statement Transaction", false);

        BankTransactions.SetShowAll(true);
        BankTransactions.SetTableView(BankTransaction);
        BankTransactions.RunModal;
    end;


    procedure GetCurrencyCode(): Code[10]
    var
        ContiniaUserCreditCard: Record "CEM Continia User Credit Card";
    begin
        ContiniaUserCreditCard.GetAccountCurrencyCode("Bank Account Type", "Bank Account No.");
    end;


    procedure FilterBankRecLines(BankAccRecon: Record "CEM Bank Acc. Reconciliation")
    begin
        Reset;
        SetRange("Bank Account Type", BankAccRecon."Bank Account Type");
        SetRange("Bank Account No.", BankAccRecon."Bank Account No.");
        SetRange("Statement No.", BankAccRecon."Statement No.");
    end;


    procedure GetStyle(): Text[20]
    begin
        if IsApplied then
            exit('Favorable');

        exit('');
    end;

    local procedure IsApplied(): Boolean
    begin
        exit("Applied Entries" > 0);
    end;


    procedure LinesExist(BankAccRecon: Record "CEM Bank Acc. Reconciliation"): Boolean
    begin
        FilterBankRecLines(BankAccRecon);
        exit(FindSet);
    end;


    procedure ShowStatementTransaction()
    var
        BankStatTrans: Record "CEM Bank Transaction";
        BankTransactions: Page "CEM Bank Transactions";
    begin
        BankStatTrans.SetRange("Entry No.", "Bank Transaction Entry No.");

        BankTransactions.SetShowAll(true);
        BankTransactions.SetTableView(BankStatTrans);
        BankTransactions.Run;
    end;
}

