table 6086311 "CEM Continia User Credit Card"
{
    Caption = 'Continia User Credit Card';
    DataCaptionFields = "Continia User ID", "Card No.";
    Permissions = TableData "Bank Account" = r;

    fields
    {
        field(1; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            NotBlank = true;
            TableRelation = "CDC Continia User Setup";

            trigger OnValidate()
            begin
                if ("Continia User ID" <> xRec."Continia User ID") and (xRec."Continia User ID" <> '') then
                    ErrorIncomplBankTransForUser("Card No.", xRec."Continia User ID", true);
            end;
        }
        field(3; "Card No."; Code[20])
        {
            Caption = 'Card No.';
            NotBlank = true;

            trigger OnValidate()
            begin
                if ("Card No." <> xRec."Card No.") and (xRec."Card No." <> '') then
                    ErrorIncomplBankTransForUser(xRec."Card No.", "Continia User ID", true);
            end;
        }
        field(10; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,,Vendor,Bank Account';
            OptionMembers = "G/L Account",,Vendor,"Bank Account";

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
            begin
                if "Account Type" <> xRec."Account Type" then
                    Validate("Account No.", '');

                if "Account Type" = "Account Type"::Vendor then begin
                    EMSetup.Get();
                    EMSetup.TestField("Expense Posting", EMSetup."Expense Posting"::"Preferable Purchase Invoice");
                    EMSetup.TestField("Post Bank Trans. on Import", false);
                end;
            end;
        }
        field(11; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const(Vendor)) Vendor;

            trigger OnValidate()
            var
                BankTransaction: Record "CEM Bank Transaction";
                CreditCard: Record "CEM Continia User Credit Card";
                Expense: Record "CEM Expense";
                EMSetup: Record "CEM Expense Management Setup";
                NewCurrencyCode: Code[10];
                OldCurrencyCode: Code[10];
                NumberOfCreditCard: Integer;
                ConfString: Text[1024];
            begin
                if (xRec."Account No." = "Account No.") then
                    exit;

                ValidateAccount();

                EMSetup.Get();
                if EMSetup."Post Bank Trans. on Import" then
                    ErrorIncomplBankTransForUser("Card No.", "Continia User ID", true);

                if not Confirm(CreditCardAccChangedQst, false) then
                    Error('');

                OldCurrencyCode := GetAccountCurrencyCode(xRec."Account Type", xRec."Account No.");
                NewCurrencyCode := GetAccountCurrencyCode("Account Type", "Account No.");

                UpdateBankAccountForUser("Card No.", "Continia User ID", "Account Type", "Account No.", OldCurrencyCode, NewCurrencyCode);

                // Update this credit card details for other users
                CreditCard.SetCurrentKey("Card No.");
                CreditCard.SetRange("Card No.", "Card No.");
                CreditCard.SetFilter("Continia User ID", '<>%1', "Continia User ID");
                NumberOfCreditCard := CreditCard.Count;
                if NumberOfCreditCard > 0 then begin
                    if NumberOfCreditCard = 1 then
                        ConfString := UpdateSimilarCardQst
                    else
                        ConfString := UpdateSimilarCardsQst;

                    if Confirm(ConfString, false, Format(NumberOfCreditCard), TableCaption,
                      CreditCard.FieldCaption("Card No."), "Card No.", CreditCard.FieldCaption("Account Type"), CreditCard.FieldCaption("Account No."))
                    then begin
                        CreditCard.FindSet();
                        repeat
                            CreditCard."Account Type" := "Account Type";
                            CreditCard."Account No." := "Account No.";
                            CreditCard.Modify();

                            if EMSetup."Post Bank Trans. on Import" then
                                ErrorIncomplBankTransForUser(CreditCard."Card No.", CreditCard."Continia User ID", true);

                            UpdateBankAccountForUser(
                              CreditCard."Card No.", CreditCard."Continia User ID", "Account Type", "Account No.", OldCurrencyCode, NewCurrencyCode);
                        until CreditCard.Next() = 0;
                    end;
                end;
            end;
        }
        field(20; "Mapping Count"; Integer)
        {
            CalcFormula = count("CEM Credit Card User Mapping" where("Card No." = field("Card No."),
                                                                      "Continia User ID" = field("Continia User ID")));
            Caption = 'Field Mapping Count';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "User Paid Credit Card"; Boolean)
        {
            Caption = 'Private Invoiced';

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
            begin
                if Rec."User Paid Credit Card" then begin
                    EMSetup.Get();
                    EMSetup.TestField("Ask User Paid Credit Card", true);
                end;

                UpdateUserPaidCrCardForUser();
            end;
        }
    }

    keys
    {
        key(Key1; "Continia User ID", "Card No.")
        {
            Clustered = true;
        }
        key(Key2; "Card No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ErrorIncomplBankTransForUser("Card No.", "Continia User ID", true);
    end;

    trigger OnInsert()
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        TestField("Continia User ID");

        if ContiniaUserSetup.Get("Continia User ID") then
            if not ContiniaUserSetup."Expense Management User" then begin
                ContiniaUserSetup."Expense Management User" := true;
                ContiniaUserSetup.Modify();
            end;
    end;

    trigger OnModify()
    begin
        TestField("Continia User ID");
    end;

    var
        BnkTrMustBePostedTxt: Label 'All bank transactions must be matched and posted.';
        CreditCardAccChangedQst: Label 'Credit Card information has been changed. Are you sure you want to update unposted bank transactions and expenses?';
        MatchedExpToPostTxt: Label 'All matched expenses must be posted.';
        UpdateSimilarCardQst: Label '%1 additional %2 record exists for %3 = %4.\\Do you want to update %5 and %6 on this record as well?';
        UpdateSimilarCardsQst: Label '%1 additional %2 records exist for %3 = %4.\\Do you want to update %5 and %6 on these records as well?';


    procedure GetAccountCurrencyCode(AccountType: Option "G/L Account",,Vendor,"Bank Account"; AccountNo: Code[20]): Code[10]
    var
        BankAccount: Record "Bank Account";
        Vendor: Record Vendor;
    begin
        if AccountNo = '' then
            exit('');

        case AccountType of
            AccountType::"G/L Account":
                exit('');

            AccountType::Vendor:
                if Vendor.Get(AccountNo) then
                    exit(Vendor."Currency Code");

            AccountType::"Bank Account":
                if BankAccount.Get(AccountNo) then
                    exit(BankAccount."Currency Code");
        end;

        exit('');
    end;

    local procedure ValidateAccount()
    begin
        CheckAccount("Account Type", "Account No.");
    end;


    procedure CheckAccount(AccountType: Option "G/L Account",,Vendor,"Bank Account"; AccountNo: Code[20])
    var
        Bank: Record "Bank Account";
        GLAccount: Record "G/L Account";
        Vendor: Record Vendor;
    begin
        if "Account No." = '' then
            exit;

        case "Account Type" of
            "Account Type"::"G/L Account":
                begin
                    GLAccount.Get("Account No.");
                    GLAccount.CheckGLAcc();
                    GLAccount.TestField("Direct Posting");
                end;

            "Account Type"::Vendor:
                begin
                    Vendor.Get("Account No.");
                    Vendor.TestField(Blocked, Vendor.Blocked::" ");
                end;

            "Account Type"::"Bank Account":
                begin
                    Bank.Get("Account No.");
                    Bank.TestField(Blocked, false);
                end;
        end;
    end;

    local procedure CurrencyChanged(): Boolean
    begin
        if "Account No." <> xRec."Account No." then
            exit(GetAccountCurrencyCode(xRec."Account Type", xRec."Account No.") <> GetAccountCurrencyCode("Account Type", "Account No."));
    end;


    procedure ErrorIncomplBankTransForUser(CardNo: Code[20]; ContiniaUserID: Code[50]; FailOnUnmatchedTrans: Boolean)
    var
        BankTransaction: Record "CEM Bank Transaction";
        Expense: Record "CEM Expense";
    begin
        BankTransaction.SetRange("Card No.", CardNo);
        BankTransaction.SetRange("Continia User ID", ContiniaUserID);
        BankTransaction.SetRange("Matched to Expense", true);
        if BankTransaction.FindSet() then
            repeat
                Expense.Get(BankTransaction.GetMatchedExpenseEntryNo());
                if not Expense.Posted then
                    Error(MatchedExpToPostTxt);
            until BankTransaction.Next() = 0;

        if FailOnUnmatchedTrans then begin
            BankTransaction.SetRange("Matched to Expense", false);
            if not BankTransaction.IsEmpty then
                Error(BnkTrMustBePostedTxt);
        end;
    end;


    procedure InitAccountTypeAndNo()
    var
        EMSetup: Record "CEM Expense Management Setup";
    begin
        EMSetup.Get();
        if EMSetup."Card Transaction Bal. No." <> '' then begin
            "Account Type" := EMSetup."Card Transaction Bal. Type";
            "Account No." := EMSetup."Card Transaction Bal. No.";
        end;
    end;


    procedure HasUserAnyCreditCard(User: Code[50]): Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        ContiniaUserCreditCard: Record "CEM Continia User Credit Card";
        EMSetup: Record "CEM Expense Management Setup";
        CorporateCreditCardAssigned: Boolean;
    begin
        EMSetup.Get();

        ContiniaUserCreditCard.SetRange("Continia User ID", User);
        CorporateCreditCardAssigned := not ContiniaUserCreditCard.IsEmpty;

        if EMSetup.IsMatchingRequiredOnDate(Today) then
            exit(CorporateCreditCardAssigned)
        else begin
            ContiniaUserSetup.Get(User);
            exit(ContiniaUserSetup."Corporate Credit Card" or CorporateCreditCardAssigned);
        end;
    end;


    procedure HasUserCreditCardAssigned(User: Code[50]): Boolean
    var
        ContiniaUserCreditCard: Record "CEM Continia User Credit Card";
    begin
        ContiniaUserCreditCard.SetRange("Continia User ID", User);
        exit(not ContiniaUserCreditCard.IsEmpty);
    end;

    local procedure UpdateBankAccountForUser(CardNo: Code[20]; ContiniaUserID: Code[50]; BankAccType: Option "G/L Account",,Vendor,"Bank Account"; BankAccNo: Code[20]; OldCurrencyCode: Code[10]; NewCurrencyCode: Code[10])
    var
        BankTransaction: Record "CEM Bank Transaction";
        Expense: Record "CEM Expense";
        EMSetup: Record "CEM Expense Management Setup";
    begin
        BankTransaction.SetCurrentKey("Card No.");
        BankTransaction.SetRange("Card No.", CardNo);
        BankTransaction.SetRange("Continia User ID", ContiniaUserID);
        BankTransaction.SetRange(Posted, false);
        if BankTransaction.FindSet() then
            repeat
                BankTransaction."Bank Account Type" := BankAccType;
                BankTransaction."Bank Account No." := BankAccNo;

                if CurrencyChanged() then begin
                    BankTransaction."Bank Currency Code" := NewCurrencyCode;
                    if Expense.Get(BankTransaction.GetMatchedExpenseEntryNo()) then
                        if (not Expense.Posted) and (Expense."Bank Currency Code" = OldCurrencyCode) then begin
                            Expense.Validate("Bank Currency Code", NewCurrencyCode);
                            Expense."Bank-Currency Amount" := BankTransaction."Bank-Currency Amount";
                            Expense.Modify();
                        end;
                end;

                BankTransaction.Modify();
            until BankTransaction.Next() = 0;
    end;

    local procedure UpdateUserPaidCrCardForUser()
    var
        BankTransaction: Record "CEM Bank Transaction";
    begin
        BankTransaction.SetCurrentKey("Card No.");
        BankTransaction.SetRange("Card No.", "Card No.");
        BankTransaction.SetRange("Continia User ID", "Continia User ID");
        BankTransaction.SetRange(Posted, false);
        BankTransaction.ModifyAll("User Paid Credit Card", "User Paid Credit Card");
    end;
}

