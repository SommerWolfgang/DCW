table 6086377 "CEM Bank Acc. Statement Line"
{
    Caption = 'Bank Account Statement Line';
    DataCaptionFields = "Bank Account Type", "Bank Account No.", Description;

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
            TableRelation = if ("Bank Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Bank Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Bank Account Type" = const(Vendor)) Vendor;
        }
        field(3; "Statement No."; Code[20])
        {
            Caption = 'Statement No.';
            TableRelation = "Bank Account Statement"."Statement No." where("Bank Account No." = field("Bank Account No."));
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
        }
        field(9; Difference; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Difference';
        }
        field(10; "Applied Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Applied Amount';
            Editable = false;

            trigger OnLookup()
            begin
                DisplayApplication();
            end;
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

            trigger OnLookup()
            begin
                DisplayApplication();
            end;
        }
        field(13; "Value Date"; Date)
        {
            Caption = 'Value Date';
        }
        field(27; "Bank Transaction Entry No."; Integer)
        {
            Caption = 'Bank Transaction Entry No.';

            trigger OnLookup()
            var
                BankStatTrans: Record "CEM Bank Transaction";
            begin
                if BankStatTrans.Get("Bank Transaction Entry No.") then
                    PAGE.Run(0, BankStatTrans);
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

    trigger OnRename()
    begin
        Error(Text000, TableCaption);
    end;

    var
        Text000: Label 'You cannot rename a %1.';

    local procedure DisplayApplication()
    var
        BankTransaction: Record "CEM Bank Transaction";
    begin
        BankTransaction.Reset();
        BankTransaction.SetCurrentKey("Bank Account Type", "Bank Account No.");
        BankTransaction.SetRange("Bank Account Type", "Bank Account Type");
        BankTransaction.SetRange("Bank Account No.", "Bank Account No.");
        BankTransaction.SetRange("Statement Status", BankTransaction."Statement Status"::"Bank Transaction Applied");
        BankTransaction.SetRange("Statement No.", "Statement No.");
        BankTransaction.SetRange("Statement Line No.", "Statement Line No.");
        BankTransaction.SetRange("Bank Statement Transaction", false);
        PAGE.Run(0, BankTransaction);
    end;


    procedure GetCurrencyCode(): Code[10]
    var
        ContiniaUserCreditCard: Record "CEM Continia User Credit Card";
    begin
        ContiniaUserCreditCard.GetAccountCurrencyCode("Bank Account Type", "Bank Account No.");
    end;
}

