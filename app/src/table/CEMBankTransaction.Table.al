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

            trigger OnValidate()
            var
                ContUserCreditCard: Record "CEM Continia User Credit Card";
                EMSetup: Record "CEM Expense Management Setup";
            begin
                EMSetup.Get;
                if not EMSetup."Use CC Mapping for dup. Cards" then begin
                    ContUserCreditCard.SetRange("Card No.", "Card No.");
                    ContUserCreditCard.FindFirst;

                    if ContUserCreditCard.Count = 1 then begin
                        "Continia User ID" := ContUserCreditCard."Continia User ID";
                        "Bank Account Type" := ContUserCreditCard."Account Type";
                        "Bank Account No." := ContUserCreditCard."Account No.";
                    end else begin
                        if "Continia User ID" <> '' then begin
                            ContUserCreditCard.SetRange("Continia User ID", "Continia User ID");
                            ContUserCreditCard.FindFirst;

                            "Bank Account Type" := ContUserCreditCard."Account Type";
                            "Bank Account No." := ContUserCreditCard."Account No.";
                        end;
                    end;
                end;
            end;
        }
        field(3; "Card Name"; Text[50])
        {
            Caption = 'Card Name';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;

            trigger OnValidate()
            begin
                TestField(Posted, false);
            end;
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(7; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';

            trigger OnValidate()
            begin
                TestField("Matched to Expense", false);
                TestField(Posted, false);
            end;
        }
        field(8; "Currency Exch. Rate"; Decimal)
        {
            Caption = 'Currency Exch. Rate';
            DecimalPlaces = 0 : 15;

            trigger OnValidate()
            begin
                TestField("Matched to Expense", false);
                TestField(Posted, false);
            end;
        }
        field(9; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate()
            begin
                TestField("Matched to Expense", false);
                TestField(Posted, false);
            end;
        }
        field(10; "Bank-Currency Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Bank-Currency Amount';

            trigger OnValidate()
            begin
                TestField("Matched to Expense", false);
                TestField(Posted, false);
            end;
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
            TableRelation = "CEM Bank Agreement"."Country/Region Code" WHERE("Bank Code" = FIELD("Bank Code"));
        }
        field(45; "CO Entry No."; Integer)
        {
            Caption = 'Continia Online Entry No.';
        }
        field(50; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup";

            trigger OnValidate()
            begin
                TestField("Matched to Expense", false);
                Validate("Card No.");
            end;
        }
        field(51; "Exclude Entry"; Boolean)
        {
            Caption = 'Exclude Entry';

            trigger OnValidate()
            begin
                TestField("Matched to Expense", false);
            end;
        }
        field(70; Posted; Boolean)
        {
            Caption = 'Posted';

            trigger OnValidate()
            begin
                if Posted then begin
                    "Posted Date/Time" := CurrentDateTime;
                    "Posted by User ID" := UserId;
                end else begin
                    "Posted Date/Time" := 0DT;
                    "Posted by User ID" := '';
                end;
            end;
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
            TableRelation = IF ("Bank Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bank Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Bank Account Type" = CONST(Vendor)) Vendor;
        }
        field(83; Reconciled; Boolean)
        {
            Caption = 'Reconciled';

            trigger OnValidate()
            begin
                if Reconciled then begin
                    "Reconciled Date/Time" := CurrentDateTime;
                    "Reconciled by User ID" := UserId;
                end else begin
                    "Reconciled Date/Time" := 0DT;
                    "Reconciled by User ID" := '';
                end;
            end;
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
            TableRelation = "CEM Bank Agreement"."Agreement ID" WHERE("Bank Code" = FIELD("Bank Code"),
                                                                       "Country/Region Code" = FIELD("Bank Country/Region Code"));
        }
        field(120; "Employee No."; Text[50])
        {
            Caption = 'Employee No.';
        }
        field(180; "Expense Type"; Code[20])
        {
            Caption = 'Expense Type';
            TableRelation = "CEM Expense Type";

            trigger OnValidate()
            var
                ExpenseType: Record "CEM Expense Type";
            begin
                TestField("Matched to Expense", false);
                ExpenseType.Get("Expense Type");
                Validate("Exclude Entry", ExpenseType."Exclude Transactions");
            end;
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

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        BankTransactionPost: Codeunit "CEM Bank Transaction-Post";
        ExpenseMatchMgt: Codeunit "CEM Expense Bank Trans. Mgt.";
    begin
        TestField("Matched to Expense", false);
        ExpenseMatchMgt.DeleteBankTransMatch(Rec);

        BankTransactionPost.RevertPosting(Rec);
    end;

    trigger OnInsert()
    var
        BankTransaction: Record "CEM Bank Transaction";
        CEMModuleLicense: Codeunit "CEM Module License";
    begin
        CEMModuleLicense.BankTransactionModuleActivated(true);

        if BankTransaction.FindLast then
            Rec."Entry No." := BankTransaction."Entry No." + 1
        else
            Rec."Entry No." := 1;
    end;

    trigger OnModify()
    var
        UsageImplementation: Codeunit "CEM Usage Implementation";
    begin
        UsageImplementation.LogBankTransUsageIfValid(Rec);
    end;

    trigger OnRename()
    begin
        Error(Text001, TableCaption);
    end;

    var
        Text001: Label 'You cannot rename a %1.';
        TransNotMatchedErr: Label 'This bank transaction is not matched to any expenses.';


    procedure CheckUnProcessedBankInbox()
    var
        Expense: Record "CEM Expense";
    begin
        Expense.CheckUnProcessedInbox;
    end;


    procedure ApplyMappingRule()
    var
        BankMappingRule: Record "CEM Bank Mapping Rule";
    begin
        if "Expense Type" <> '' then
            exit;

        BankMappingRule.UseBankMappingRules(Rec);
        if "Expense Type" <> '' then
            Rec.Modify;
    end;


    procedure MatchAndCreateExpense()
    var
        Expense: Record "CEM Expense";
        EMSetup: Record "CEM Expense Management Setup";
        ExpenseType: Record "CEM Expense Type";
        SendExpense: Codeunit "CEM Expense - Send to User";
        Matching: Codeunit "CEM Expense Bank Trans. Mgt.";
        NextEntryNo: Integer;
    begin
        TestField("Bank Statement Transaction", false);

        EMSetup.Get;
        if ExpenseType.Get("Expense Type") then
            if ExpenseType."Exclude Transactions" then
                exit;

        if Matching.MatchInsertExpense(Rec, Expense) then
            exit;

        Expense.Reset;

        if Expense.FindLast then
            NextEntryNo := Expense."Entry No." + 1
        else
            NextEntryNo := 1;

        Expense.Init;
        Expense."Entry No." := NextEntryNo;
        Expense.Validate("Continia User ID", "Continia User ID");
        if EMSetup."Exp. Description From Bank" then
            Expense.Description := CopyStr("Business Name", 1, MaxStrLen(Expense.Description));
        Expense."Business Description" := "Business Name";
        Expense."Document Date" := "Document Date";
        Expense."Country/Region Code" := "Business Country/Region";
        Expense."Currency Code" := "Currency Code";
        Expense.Validate(Amount, Amount);
        Expense."Bank-Currency Amount" := "Bank-Currency Amount";
        Expense."Document Time" := "Document Time";

        Expense.Validate("Expense Type", "Expense Type");
        Expense."Created By User ID" := UserId;
        Expense.SkipLimitCalculation(true);
        Expense.Insert(true);

        Expense.SkipLimitCalculation(false);
        Matching.InsertMatch(Rec, Expense);
        Expense.Get(Expense."Entry No.");
        if Expense.Status = Expense.Status::Open then begin
            SendExpense.SetBatchMode(true);
            SendExpense.Run(Expense);
        end;

        Rec.Get("Entry No.");
    end;


    procedure ShowMatchedExpense()
    var
        Expense: Record "CEM Expense";
        ExpHeader: Record "CEM Expense Header";
        ExpenseMatch: Record "CEM Expense Match";
    begin
        if not "Matched to Expense" then
            Error(TransNotMatchedErr);

        ExpenseMatch.SetCurrentKey("Transaction Entry No.");
        ExpenseMatch.SetRange("Transaction Entry No.", "Entry No.");
        ExpenseMatch.FindFirst;

        Expense.SetRange("Entry No.", ExpenseMatch."Expense Entry No.");
        Expense.FindFirst;
        if Expense."Settlement No." = '' then
            if not Expense.Posted then
                PAGE.Run(PAGE::"CEM Expense Card", Expense)
            else
                PAGE.Run(PAGE::"CEM Posted Expense Card", Expense)
        else begin
            ExpHeader.Get(ExpHeader."Document Type"::Settlement, Expense."Settlement No.");
            if not ExpHeader.Posted then
                PAGE.Run(PAGE::"CEM Settlement Card", ExpHeader)
            else
                PAGE.Run(PAGE::"CEM Posted Settlement Card", ExpHeader);
        end;
    end;


    procedure GetBankAccountCurrencyCode(): Code[10]
    var
        UserCreditCard: Record "CEM Continia User Credit Card";
    begin
        if UserCreditCard.Get("Continia User ID", "Card No.") then
            exit(UserCreditCard.GetAccountCurrencyCode(UserCreditCard."Account Type", UserCreditCard."Account No."));

        exit('');
    end;


    procedure Navigate()
    var
        Navigate: Codeunit "CEM Navigate Bnk Trans. - Find";
    begin
        if "Entry No." <> 0 then
            Navigate.NavigateBankTransaction(Rec);
    end;


    procedure LookupDimensions()
    var
        EmDim: Record "CEM Dimension";
        ExpDim: Page "CEM Dimensions";
    begin
        EmDim.SetRange("Table ID", DATABASE::"CEM Bank Transaction");
        EmDim.SetRange("Document Type", 0);
        EmDim.SetRange("Document No.", '');
        EmDim.SetRange("Doc. Ref. No.", "Entry No.");

        ExpDim.SetTableView(EmDim);
        ExpDim.SetReadOnly;
        ExpDim.RunModal;
    end;


    procedure GetMatchedExpenseEntryNo(): Integer
    var
        ExpenseMatch: Record "CEM Expense Match";
    begin
        ExpenseMatch.SetRange("Transaction Entry No.", "Entry No.");
        if ExpenseMatch.FindFirst then
            exit(ExpenseMatch."Expense Entry No.");

        exit(0);
    end;


    procedure IsApplied(): Boolean
    begin
        if ("Statement Status" = "Statement Status"::"Bank Transaction Applied") and
          ("Statement No." <> '') and
          ("Statement Line No." <> 0)
        then
            exit(true);

        exit(false);
    end;


    procedure SetStyle(): Text[1024]
    begin
        if IsApplied then
            exit('Favorable');

        exit('');
    end;


    procedure GetExpenseStatus(): Integer
    var
        Expense: Record "CEM Expense";
        ExpenseStatus: Option "Not Matched",Open,"Pending Expense User","Pending Approval",Released,Posted;
    begin
        if not Expense.Get(GetMatchedExpenseEntryNo) then
            exit(ExpenseStatus::"Not Matched");

        case Expense.Status of
            Expense.Status::Open:
                exit(ExpenseStatus::Open);
            Expense.Status::"Pending Expense User":
                exit(ExpenseStatus::"Pending Expense User");
            Expense.Status::"Pending Approval":
                exit(ExpenseStatus::"Pending Approval");
            Expense.Status::Released:
                if Expense.Posted then
                    exit(ExpenseStatus::Posted)
                else
                    exit(ExpenseStatus::Released);
        end;
    end;


    procedure SetUnprocessedFilters()
    var
        EMSetup: Record "CEM Expense Management Setup";
    begin
        EMSetup.Get;

        SetRange("Bank Statement Transaction", false);
        SetRange("Exclude Entry", false);

        if (not EMSetup."Create Expense w. Transaction") and (not EMSetup."Post Bank Trans. on Import") then begin
            SetRange("Matched to Expense", false);
            SetRange(Posted);

            if IsEmpty then begin
                SetRange("Matched to Expense");
                SetRange(Posted, false);
            end;
        end else begin
            SetRange("Matched to Expense", false);
            SetRange(Posted);
        end;
    end;


    procedure SetProcessedFilters()
    begin
        SetRange("Bank Statement Transaction", false);
        SetRange("Exclude Entry", false);
        SetRange("Matched to Expense", true);
        SetRange(Posted, true);
    end;


    procedure SetExcludedFilters()
    begin
        SetRange("Bank Statement Transaction", false);
        SetRange("Exclude Entry", true);
        SetRange("Matched to Expense");
        SetRange(Posted);
    end;


    procedure GetRecordID(var RecID: RecordID)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        RecID := RecRef.RecordId;
        RecRef.Close;
    end;
}

