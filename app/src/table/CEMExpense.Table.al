table 6086320 "CEM Expense"
{
    Caption = 'Expense';
    DataCaptionFields = "Entry No.", "Continia User ID", "Expense Type", Description;
    Permissions = TableData "Default Dimension" = r,
                  TableData "Handled IC Inbox Sales Line" = rimd,
                  TableData "CDC Continia User Setup" = r,
                  TableData "CEM Expense Management Setup" = r,
                  TableData "CEM Expense Type" = r,
                  TableData "CEM Continia User Credit Card" = r,
                  TableData "CEM Bank Agreement" = r,
                  TableData "CEM Expense Inbox" = r,
                  TableData "CEM Bank Transaction" = r,
                  TableData "CEM Bank Transaction Inbox" = r,
                  TableData "CEM Credit Card User Mapping" = r,
                  TableData "CEM Expense Match" = r;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
        }
        field(3; "Continia User Name"; Text[50])
        {
            CalcFormula = lookup("CDC Continia User".Name where("User ID" = field("Continia User ID")));
            Caption = 'Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
            NotBlank = true;
        }
        field(7; "Date Created"; Date)
        {
            Caption = 'Date Created';
            Editable = false;
        }
        field(8; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            NotBlank = true;
            TableRelation = "CEM Country/Region";

            trigger OnValidate()
            begin
                Validate("Expense Type");
            end;
        }
        field(9; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(10; "No Refund"; Boolean)
        {
            Caption = 'No Refund';
        }
        field(11; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(12; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
        }
        field(13; "Created Doc. Type"; Integer)
        {
            Caption = 'Created Doc. Type';
            Editable = false;
        }
        field(14; "Created Doc. Subtype"; Integer)
        {
            Caption = 'Created Doc. Subtype';
            Editable = false;
        }
        field(15; "Created Doc. ID"; Code[20])
        {
            Caption = 'Created Doc. ID';
            Editable = false;
        }
        field(16; "Created Doc. Ref. No."; Integer)
        {
            Caption = 'Created Doc. Ref. No.';
            Editable = false;
        }
        field(17; "Created By User ID"; Code[50])
        {
            Caption = 'Created By User ID';
            Editable = false;
        }
        field(18; "Bank-Currency Amount"; Decimal)
        {
            AutoFormatExpression = "Bank Currency Code";
            AutoFormatType = 1;
            Caption = 'Bank-Currency Amount';
            Editable = false;
        }
        field(19; "Bank Currency Code"; Code[10])
        {
            Caption = 'Bank Currency Code';
            Editable = false;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                UpdateAmount(FieldNo("Bank Currency Code"));
            end;
        }
        field(20; "Document Time"; Time)
        {
            Caption = 'Document Time';
            Editable = false;
        }
        field(21; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
        }
        field(25; "Transfer Attachments to CO"; Boolean)
        {
            Caption = 'Transfer Attachments to CO';
        }
        field(26; "Allocated Amount (LCY)"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("CEM Expense Allocation"."Amount (LCY)" where("Expense Entry No." = field("Entry No.")));
            Caption = 'Allocated Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "Business Description"; Text[250])
        {
            Caption = 'Business Description';
            Editable = false;
        }
        field(28; "Amount w/o VAT"; Decimal)
        {
            Caption = 'Amount without VAT';

            trigger OnValidate()
            begin
                TestStatusAllowsChange();
                "VAT Amount" := Amount - "Amount w/o VAT";
            end;
        }
        field(29; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            Description = 'Obsolete';

            trigger OnValidate()
            begin
                TestStatusAllowsChange();
                "Amount w/o VAT" := Amount - "VAT Amount";
            end;
        }
        field(30; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(31; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(32; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                ContiniaUser: Record "CDC Continia User";
                Vendor: Record Vendor;
            begin
            end;
        }
        field(43; "Register No."; Integer)
        {
            Caption = 'Register No.';
            TableRelation = "CEM Register";
        }
        field(50; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;

            trigger OnValidate()
            begin
                Validate(Billable, "Job No." <> '');
                if "Job No." = '' then
                    Validate("Job Task No.", '');

                AddDefaultDim(CurrFieldNo);
            end;
        }
        field(51; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));

            trigger OnValidate()
            begin
                Validate(Billable, "Job Task No." <> '');
                AddDefaultDim(CurrFieldNo);
            end;
        }
        field(52; Billable; Boolean)
        {
            Caption = 'Billable';

            trigger OnValidate()
            begin
                if Billable and ("Job No." <> '') and ("Job Task No." <> '') then
                    Validate("Job Line Type", "Job Line Type"::Contract)
                else
                    Validate("Job Line Type", "Job Line Type"::" ");
            end;
        }
        field(53; "Job Line Type"; Option)
        {
            Caption = 'Job Line Type';
            Editable = false;
            OptionCaption = ' ,Budget,Billable,Both Budget and Billable';
            OptionMembers = " ",Schedule,Contract,"Both Schedule and Contract";

            trigger OnValidate()
            begin
                if "Job Line Type" = "Job Line Type"::Contract then begin
                    TestField("Job No.");
                    TestField("Job Task No.");
                end;
            end;
        }
        field(60; "Cash/Private Card"; Boolean)
        {
            Caption = 'Cash/Private Card';

            trigger OnValidate()
            begin
                if "Cash/Private Card" then
                    TestField("Matched to Bank Transaction", false);

                if not SupressAllocationsExist then
                    if AllocationExists() then
                        Error(ExpenseAllocatedErr, FieldCaption("Cash/Private Card"));

            end;
        }
        field(61; "Reimbursement Register No."; Integer)
        {
            Caption = 'Reimbursement Register No.';
            TableRelation = "CEM Register";
        }
        field(62; "Reimbursement Method"; Option)
        {
            Caption = 'Reimbursement Method';
            OptionCaption = 'Internal (on User),External Payroll System,Both';
            OptionMembers = "Vendor (on User)","External System",Both;
        }
        field(63; Reimbursed; Boolean)
        {
            Caption = 'Reimbursed';
        }
        field(65; "Employee Reimbursed"; Boolean)
        {
            Caption = 'Employee Reimbursed';
        }
        field(71; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(72; Comment; Boolean)
        {
            CalcFormula = exist("CEM Comment" where("Table ID" = const(6086320),
                                                     "Document Type" = const(Budget),
                                                     "Document No." = const(''),
                                                     "Doc. Ref. No." = field("Entry No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(73; "Original Expense Entry No."; Integer)
        {
            Caption = 'Original Expense Entry No.';
        }
        field(74; "Entry No. (Code)"; Code[20])
        {
            Caption = 'Entry No. (Code)';
        }
        field(75; "Usage Entry No."; Integer)
        {
            Caption = 'Usage Entry No.';
            Editable = false;
        }
        field(76; "Notification Type"; Option)
        {
            Caption = 'Notification Type';
            OptionMembers = " ","New document","Important update","New history status";
        }
        field(100; "Expense GUID"; Guid)
        {
            Caption = 'Expense GUID';
        }
        field(109; "Expense Account Type"; Option)
        {
            Caption = 'Expense Account Type';
            OptionCaption = ' ,G/L Account,,,Item';
            OptionMembers = " ","G/L Account",,,Item;
        }
        field(110; "Expense Account"; Code[20])
        {
            Caption = 'Expense Account';
        }
        field(111; "Exp. Account Manually Changed"; Boolean)
        {
            Caption = 'Expense Account Manually Changed';
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
        field(114; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(115; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(120; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending Expense User,Pending Approval,Released';
            OptionMembers = Open,"Pending Expense User","Pending Approval",Released;
        }
        field(130; "Current Reminder Level"; Integer)
        {
            CalcFormula = max("CEM Reminder"."No." where("Table ID" = const(6086320),
                                                          "Document Type" = const(Budget),
                                                          "Document No." = const(''),
                                                          "Doc. Ref. No." = field("Entry No.")));
            Caption = 'Current Reminder Level';
            Editable = false;
            FieldClass = FlowField;
        }
        field(132; "Settlement No."; Code[20])
        {
            Caption = 'Settlement No.';
        }
        field(133; "Settlement Line No."; Integer)
        {
            Caption = 'Settlement Line No.';
        }
        field(180; "Expense Type"; Code[20])
        {
            Caption = 'Expense Type';
        }
        field(200; "Matched to Bank Transaction"; Boolean)
        {
            Caption = 'Matched to Bank Transaction';
            Editable = false;
        }
        field(219; "Response from Dataloen"; Text[100])
        {
            Caption = 'Response from Dataloen';
        }
        field(220; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;

            trigger OnValidate()
            begin
                "Posted Date/Time" := CurrentDateTime;
                "Posted by User ID" := UserId;
            end;
        }
        field(221; "Posted Date/Time"; DateTime)
        {
            Caption = 'Posted Date Time';
            Editable = false;
        }
        field(222; "Posted by User ID"; Code[50])
        {
            Caption = 'Posted by User ID';
            Editable = false;
        }
        field(223; "Expense Completed"; Boolean)
        {
            Caption = 'Expense Completed';
        }
        field(224; "Continia Online Version No."; Text[100])
        {
            Caption = 'Continia Online Version No.';
        }
        field(260; "No. of Attachments"; Integer)
        {
            CalcFormula = count("CEM Attachment" where("Table ID" = const(6086320),
                                                        "Document Type" = const(Budget),
                                                        "Document No." = filter(''),
                                                        "Doc. Ref. No." = field("Entry No.")));
            Caption = 'Attachments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(270; "No. of Attendees"; Integer)
        {
            CalcFormula = count("CEM Attendee" where("Table ID" = const(6086320),
                                                      "Doc. Ref. No." = field("Entry No.")));
            Caption = 'No. of Attendees';
            Editable = false;
            FieldClass = FlowField;
        }
        field(271; "Expense Header GUID"; Guid)
        {
            Caption = 'Settlement GUID';
        }
        field(272; "Updated By Delegation User"; Code[50])
        {
            Caption = 'Updated By Delegation User';
        }
        field(280; "External Posting Account Type"; Option)
        {
            Caption = 'External Posting Account Type';
            OptionCaption = ' ,Lessor Pay Type,Dataloen Pay Type';
            OptionMembers = " ","Lessor Pay Type","Dataloen Pay Type";
        }
        field(285; "External Posting Account No."; Code[20])
        {
            Caption = 'External Posting Account No.';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Expense GUID")
        {
        }
        key(Key3; "Continia User ID", "Currency Code", "Document Date")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key4; "Continia User ID", "Document Date")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key5; "Continia User ID", Status, Posted, "Settlement No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key6; "Created Doc. Type", "Created Doc. Subtype", "Created Doc. ID", "Created Doc. Ref. No.")
        {
        }
        key(Key7; Status)
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key8; Posted, "Settlement No.")
        {
        }
        key(Key9; Posted, "Continia User ID", Status, "Document Date")
        {
        }
        key(Key10; "Settlement No.", Posted, "Posted Date/Time", "Entry No.")
        {
        }
        key(Key11; "Settlement No.", "Settlement Line No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key12; "Settlement No.", "Matched to Bank Transaction", "Currency Code")
        {
        }
        key(Key13; "Continia User ID", Reimbursed)
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key14; "Continia User ID", "Document Date", Posted, Reimbursed, "Expense Type")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key15; "Register No.")
        {
        }
        key(Key16; "Reimbursement Register No.")
        {
        }
        key(Key17; "Continia User ID", "Document Date", "Currency Code", Amount)
        {
        }
        key(Key18; "Continia User ID", "Document Date", "Expense Type")
        {
            SumIndexFields = "Amount (LCY)";
        }
    }

    var
        SkipCheckRefundWithinLimitAndAlloc: Boolean;
        SkipSendToExpUser: Boolean;
        SupressAllocationsExist: Boolean;
        SuspendInboxCheck: Boolean;
        AllocatedTxt: Label 'Allocated';
        BothExpMatchedErr: Label 'Both expenses are matched to bank transactions and can therefore not be merged.';
        CannotChangeWhenSttl: Label '%1 cannot be changed when assigned to a settlement.';
        ConfirmDetachExpenseMultiple: Label 'Do you want to detach %1 expenses from this settlement?';
        ConfirmDetachExpenseSingle: Label 'Do you want to detach the expense from this settlement?';
        ConfirmMergeTxt: Label 'Do you want to merge the two selected expenses?';
        DelegateUpdateTxt: Label 'Updated by delegated user %1.';
        DeleteAborted: Label 'The expense was not deleted as it was matched with a transaction.';
        DeleteAndExclude: Label 'The expense is matched to a transaction.\The transaction will not be deleted but will be excluded from automatic matching.\Are you sure you want to delete the expense?';
        EMInboxFoundErr: Label '%1 %2 cannot be updated as there are one or more unprocessed lines in the %3.\\Please process the related lines in the %3 before making changes to this %1.';
        ExpAutoAllocateTxt: Label 'Expense automatically allocated. Expense Type %1 automatically allocates expenses above %2 %3. The difference is not refundable.';
        ExpenseAllocatedErr: Label 'This expense has been allocated and therefore you cannot change %1.';
        ExpenseLimitTimedTxt: Label 'Your company policy defines a limit of %1 %2 per %3 on expenses.';
        ExpenseLimitTxt: Label 'Your company policy defines a limit of %1 %2 per document.';
        ExpensePlural: Label 'Expenses';
        ExpTypeAttNotAllowed: Label 'The %1 %2 does not allow attendees. Please remove them.';
        ExpTypeAttNotReq: Label 'The %1 %2 does not require attendees.';
        ExpTypeLimitTimedTxt: Label 'Your company policy defines a limit of %2 %3 per %4 for Expense Type %1.';
        ExpTypeLimitTxt: Label 'Your company policy defines a limit of %2 %3 per document for Expense Type %1.';
        FileAlreadyExistErr: Label 'The file name ''%1'' already exists for this expense and cannot be imported.\\Please rename it before importing.';
        ItemRequiresPurchInv: Label 'Items are allowed only when using purchase invoice posting.';
        MergeAmtDiffQuestion: Label 'The amount on the two expenses selected are not the same.\The Amount (%1 %2) from the expense matched to the bank transaction will be used.\\Do you want to continue?';
        MissingBankTransTxt: Label 'Missing Bank Transaction';
        NoExpInSelection: Label 'Please select one or more expenses to detach.';
        OneExpMatchedErr: Label 'At least one of the expenses must be matched.';
        OneOrMoreBankTransError: Label 'There are one or more unprocessed entries in the Bank Transaction Inbox.';
        OneOrMoreInboxError: Label 'There are one or more unprocessed entries in the %1.';
        ProcessInboxAsapTxt: Label '\\You should process these as soon as possible.';
        PurchasePostingNotAllowed: Label '%1 %2 cannot be %3, when %4 with %5 exists';
        ReopenMultiplePendExpUsrQst: Label 'This will reopen %1 expenses.\Reopening a document can discard user''s changes when the Mobile App doesn''t have internet connection.\\Are you sure you want to continue?';
        ReopenMultipleQst: Label 'This will reopen %1 expenses.\Are you sure you want to continue?';
        ReopenSinglePendExpUsrQst: Label 'Reopening a document can discard user''s changes when the Mobile App doesn''t have internet connection.\\Are you sure you want to continue?';
        ReopenSingleQst: Label 'This will reopen the expense.\Are you sure you want to continue?';
        SettlementReleasedTxt: Label 'The settlement must not be released.';
        StatusNotAllowed: Label 'Status must be Open or Pending Expense User in %1 %2.';
        SystemLimitTimedTxt: Label 'Your company policy defines a limit of %1 %2 per %3.';
        SystemLimitTxt: Label 'Your company policy defines a limit of %1 %2 per document.';
        Text001: Label 'You cannot rename a %1.';
        UnableToMergeWithAllocErr: Label 'Expense %1 cannot be merged when it has been allocated to one or more lines.';

    local procedure UpdateAmount(CalledByFieldNo: Integer)
    var
        EMSetup: Record "CEM Expense Management Setup";
        BankAccCurrency: Record Currency;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyDate: Date;
        AccountCurrencyFactor: Decimal;
        ExpenseCurrencyFactor: Decimal;
    begin
        EMSetup.Get();
        if CalledByFieldNo <> FieldNo("Bank Currency Code") then
            TestField("Matched to Bank Transaction", false);

        if "Document Date" = 0D then
            CurrencyDate := WorkDate()
        else
            CurrencyDate := "Document Date";

        ExpenseCurrencyFactor := 1;
        AccountCurrencyFactor := 1;
        if "Currency Code" <> '' then begin
            ExpenseCurrencyFactor := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
            Currency.Get("Currency Code");
            Currency.CheckAmountRoundingPrecision();
        end else
            Currency.InitRoundingPrecision();

        if "Bank Currency Code" <> '' then begin
            AccountCurrencyFactor := CurrExchRate.ExchangeRate(CurrencyDate, "Bank Currency Code");
            BankAccCurrency.Get("Bank Currency Code");
            BankAccCurrency.CheckAmountRoundingPrecision();
        end else
            BankAccCurrency.InitRoundingPrecision();

        case CalledByFieldNo of
            // CURRENCY CODE
            FieldNo("Currency Code"):
                Validate(Amount);

            // AMOUNT
            FieldNo(Amount):
                begin
                    if Currency.Get("Currency Code") then begin
                        Amount := Round(Amount, Currency."Amount Rounding Precision");
                        "Amount (LCY)" :=
                          Round(CurrExchRate.ExchangeAmtFCYToLCY(CurrencyDate, "Currency Code", Amount, ExpenseCurrencyFactor),
                          Currency."Amount Rounding Precision");
                    end else begin
                        Amount := Round(Amount, Currency."Amount Rounding Precision");
                        "Amount (LCY)" := Round(Amount);
                    end;

                    if "Matched to Bank Transaction" then
                        if "Currency Code" = "Bank Currency Code" then
                            "Bank-Currency Amount" := Round(Amount, BankAccCurrency."Amount Rounding Precision")
                        else
                            "Bank-Currency Amount" :=
                               Round(CurrExchRate.ExchangeAmtLCYToFCY(CurrencyDate, "Bank Currency Code", "Amount (LCY)", AccountCurrencyFactor),
                                BankAccCurrency."Amount Rounding Precision")
                    else
                        "Bank-Currency Amount" := 0;

                end;

            // AMOUNT (LCY)
            FieldNo("Amount (LCY)"):
                begin
                    if "Currency Code" <> '' then
                        Amount :=
                          Round(CurrExchRate.ExchangeAmtLCYToFCY(CurrencyDate, "Currency Code", "Amount (LCY)", ExpenseCurrencyFactor),
                          Currency."Amount Rounding Precision")
                    else
                        Amount := Round("Amount (LCY)", Currency."Amount Rounding Precision");

                    if "Matched to Bank Transaction" then
                        if "Currency Code" = "Bank Currency Code" then
                            "Bank-Currency Amount" := Round(Amount, BankAccCurrency."Amount Rounding Precision")
                        else
                            "Bank-Currency Amount" :=
                               Round(CurrExchRate.ExchangeAmtLCYToFCY(CurrencyDate, "Bank Currency Code", "Amount (LCY)", AccountCurrencyFactor),
                                BankAccCurrency."Amount Rounding Precision")
                    else
                        "Bank-Currency Amount" := 0;

                end;

            // BANK ACC. CURRENCY CODE
            FieldNo("Bank Currency Code"):
                if "Matched to Bank Transaction" or (not EMSetup.IsMatchingRequiredOnDate("Document Date")) then
                    if "Currency Code" = "Bank Currency Code" then
                        "Bank-Currency Amount" := Round(Amount, BankAccCurrency."Amount Rounding Precision")
                    else
                        "Bank-Currency Amount" :=
                          Round(CurrExchRate.ExchangeAmtLCYToFCY(CurrencyDate, "Bank Currency Code", "Amount (LCY)", AccountCurrencyFactor),
                            BankAccCurrency."Amount Rounding Precision")
                else
                    "Bank-Currency Amount" := 0;
        end;
    end;


    procedure NextReminderDate(): Date
    var
        EMReminder: Record "CEM Reminder";
    begin
        exit(EMReminder.NextReminderDate("Continia User ID", DATABASE::"CEM Expense", 0, "Settlement No.", "Entry No.", GetEarliestDate()));
    end;

    procedure ShowReminders()
    begin
    end;


    procedure CalcMatchedAmount(): Decimal
    begin
    end;

    procedure MatchToBankTrans()
    begin
    end;

    procedure AddAttachment(var TempFile: Record "CDC Temp File" temporary)
    begin
    end;

    procedure MergeExpenses(var Expense1: Record "CEM Expense"; var Expense2: Record "CEM Expense")
    var
        TempFile: Record "CDC Temp File" temporary;
        EMAttachment: Record "CEM Attachment";
        MatchedExpense: Record "CEM Expense";
        UnMatchedExpense: Record "CEM Expense";
        ExpenseMatch: Record "CEM Expense Match";
        NewExpenseMatch: Record "CEM Expense Match";
        GLSetup: Record "General Ledger Setup";
        CurrCode: Code[20];
        LastEntry: Integer;
    begin
        if Expense1."Matched to Bank Transaction" and Expense2."Matched to Bank Transaction" then
            Error(BothExpMatchedErr);

        if (not Expense1."Matched to Bank Transaction") and (not Expense2."Matched to Bank Transaction") then
            Error(OneExpMatchedErr);

        if Expense1."Matched to Bank Transaction" then begin
            MatchedExpense := Expense1;
            UnMatchedExpense := Expense2;
            UnMatchedExpense.TestField("Cash/Private Card", false);
        end else begin
            Expense2.TestField("Matched to Bank Transaction");

            MatchedExpense := Expense2;
            UnMatchedExpense := Expense1;
            UnMatchedExpense.TestField("Cash/Private Card", false);
        end;

        if not Confirm(ConfirmMergeTxt, true) then
            exit;

        if MatchedExpense.Amount <> UnMatchedExpense.Amount then begin
            GLSetup.Get();
            if MatchedExpense."Currency Code" <> '' then
                CurrCode := MatchedExpense."Currency Code"
            else
                CurrCode := GLSetup."LCY Code";

            if not Confirm(MergeAmtDiffQuestion, true, CurrCode, MatchedExpense.Amount) then
                Error('');
        end;

        MatchedExpense.TestField(Posted, false);
        UnMatchedExpense.TestField(Posted, false);

        if MatchedExpense.AllocationExists() then
            Error(UnableToMergeWithAllocErr, MatchedExpense."Entry No.");

        if UnMatchedExpense.AllocationExists() then
            if (UnMatchedExpense."Currency Code" <> MatchedExpense."Currency Code") or
              (UnMatchedExpense.Amount <> MatchedExpense.Amount) or
              (UnMatchedExpense."Amount (LCY)" <> MatchedExpense."Amount (LCY)")
            then
                Error(UnableToMergeWithAllocErr, UnMatchedExpense."Entry No.");

        ExpenseMatch.SetRange("Expense Entry No.", MatchedExpense."Entry No.");
        if ExpenseMatch.FindSet() then
            repeat
                NewExpenseMatch := ExpenseMatch;
                NewExpenseMatch."Expense Entry No." := UnMatchedExpense."Entry No.";
                NewExpenseMatch.Insert();
                ExpenseMatch.Delete();
            until ExpenseMatch.Next() = 0;

        EMAttachment.SetCurrentKey("Table ID", "Document Type", "Document No.", "Doc. Ref. No.");
        EMAttachment.SetRange("Table ID", DATABASE::"CEM Expense");
        EMAttachment.SetRange("Document Type", 0);
        EMAttachment.SetRange("Document No.", '');
        EMAttachment.SetRange("Doc. Ref. No.", MatchedExpense."Entry No.");
        if EMAttachment.FindLast() then
            LastEntry := EMAttachment."Entry No.";

        EMAttachment.SetCurrentKey("Table ID", "Document Type", "Document No.", "Doc. Ref. No.");
        EMAttachment.SetRange("Table ID", DATABASE::"CEM Expense");
        EMAttachment.SetRange("Document Type", 0);
        EMAttachment.SetRange("Document No.", '');
        EMAttachment.SetRange("Doc. Ref. No.", MatchedExpense."Entry No.");
        if EMAttachment.Find('+') then
            repeat
                LastEntry := LastEntry + 1;
                EMAttachment.GetAttachment(TempFile);
                EMAttachment.Rename(
                  EMAttachment."Table ID",
                  EMAttachment."Document Type",
                  EMAttachment."Document No.",
                  UnMatchedExpense."Entry No.",
                  LastEntry);

                EMAttachment.SetAttachment(TempFile, true);
            until EMAttachment.Next(-1) = 0;

        UnMatchedExpense."Continia User ID" := MatchedExpense."Continia User ID";
        UnMatchedExpense."Document Date" := MatchedExpense."Document Date";
        UnMatchedExpense."Country/Region Code" := MatchedExpense."Country/Region Code";
        UnMatchedExpense."Currency Code" := MatchedExpense."Currency Code";
        UnMatchedExpense.Amount := MatchedExpense.Amount;
        UnMatchedExpense."Amount (LCY)" := MatchedExpense."Amount (LCY)";
        UnMatchedExpense."Bank-Currency Amount" := MatchedExpense."Bank-Currency Amount";
        UnMatchedExpense."Bank Currency Code" := MatchedExpense."Bank Currency Code";
        UnMatchedExpense."Matched to Bank Transaction" := MatchedExpense."Matched to Bank Transaction";
        UnMatchedExpense.Modify(true);

        MatchedExpense."Matched to Bank Transaction" := false;
        MatchedExpense.Delete(true);
    end;


    procedure HasExpenseComment(): Boolean
    begin
        CalcFields(Comment);
        exit(Comment);
    end;


    procedure HasErrorComment(ShowFirstError: Boolean; RunValidationChecks: Boolean): Boolean
    begin
    end;

    procedure HasWarningComment(ShowFirstError: Boolean): Boolean
    begin
    end;

    procedure HasApprovalComment(): Boolean
    var
        ApprovalCmtLine: Record "Approval Comment Line";
    begin
        ApprovalCmtLine.SetCurrentKey("Table ID", "Document Type", "Document No.");
        ApprovalCmtLine.SetRange("Table ID", DATABASE::"CEM Expense");
        ApprovalCmtLine.SetRange("Document Type", ApprovalCmtLine."Document Type"::Invoice);
        ApprovalCmtLine.SetRange("Document No.", Format("Entry No."));
        exit(not ApprovalCmtLine.IsEmpty);
    end;


    procedure SetSkipSendToExpUser(NewSkipSendToExpUser: Boolean)
    begin
        SkipSendToExpUser := NewSkipSendToExpUser;
    end;


    procedure CheckUnProcessedInbox()
    begin
    end;

    procedure SupressAllocationCheck()
    begin
        SupressAllocationsExist := true;
    end;

    procedure AllocationExists(): Boolean
    var
        ExpenseAllocation: Record "CEM Expense Allocation";
    begin
        ExpenseAllocation.SetCurrentKey("Expense Entry No.");
        ExpenseAllocation.SetRange("Expense Entry No.", "Entry No.");
        exit(not ExpenseAllocation.IsEmpty);
    end;


    procedure LookupGlobalDim(var Text: Text[1024]; DimNo: Integer): Boolean
    begin
        Text := '';
    end;


    procedure Navigate()
    begin
    end;


    procedure SetSuspendInboxCheck(NewSuspend: Boolean)
    begin
        SuspendInboxCheck := NewSuspend;
    end;


    procedure PostingSetupChanged(var NewCalculatedAccount: Code[20]): Boolean
    begin
    end;

    procedure ExistsInInbox(): Boolean
    begin
    end;

    procedure CheckInboxAndThrowError()
    begin
    end;

    procedure ThrowInboxError()
    begin
    end;

    procedure BankIntegrationExists(): Boolean
    begin
    end;

    procedure TransactionInboxEntriesExist(): Boolean
    begin
    end;

    procedure IsSyncRequired(): Boolean
    begin
    end;

    procedure AddDefaultDim(ValidatedFieldNo: Integer)
    begin
    end;

    procedure GetMatchingBankEntryNo(): Integer
    begin
    end;

    procedure GetAttendeesForDisplay() DisplayTxt: Text[150]
    begin
    end;

    procedure DrillDownAttendees()
    begin
    end;

    procedure SendToExpenseUser()
    begin
    end;

    procedure LookupDimensions(Editable: Boolean)
    begin
    end;

    procedure LookupExtraFields(Editable: Boolean)
    begin
    end;

    procedure ShowAttachments()
    begin
    end;

    procedure GetOverviewDetails() AddInfo: Text[250]
    begin
    end;

    procedure GetNextDocumentLineNo() LineNo: Integer
    begin
    end;

    procedure OpenDocumentCard()
    begin
    end;

    procedure SplitAndAllocate()
    begin
    end;

    procedure LookupComments()
    begin
    end;

    procedure DetachExpFromSettlement(var Expense: Record "CEM Expense")
    var
        Expense2: Record "CEM Expense";
        ConfirmText: Text[250];
    begin
        if Expense.Count = 0 then
            Error(NoExpInSelection);

        if Expense.Count = 1 then
            ConfirmText := ConfirmDetachExpenseSingle
        else
            ConfirmText := ConfirmDetachExpenseMultiple;

        if Confirm(ConfirmText, false, Expense.Count) then begin
            Expense.FindFirst();
            repeat
                Expense2.Get(Expense."Entry No.");
                Expense2.Validate("Settlement No.", '');
                Expense2.Modify(true);
            until Expense.Next() = 0;
        end;
    end;


    procedure AttachExpenseToSettlement(var Expense: Record "CEM Expense")
    begin
    end;

    procedure LookupPostingAccount(var Text: Text[1024]): Boolean
    begin
    end;

    procedure GetEntryNo(): Integer
    var
        Expense: Record "CEM Expense";
    begin
        if Expense.FindLast() then
            exit(Expense."Entry No." + 1)
        else
            exit(1);
    end;


    procedure GetEarliestDate(): Date
    begin
        //BETWEEN DOCUMENT DATE AND DATE CREATED

        if "Document Date" = 0D then
            exit("Date Created");

        if "Date Created" = 0D then
            exit("Document Date");

        if "Date Created" < "Document Date" then
            exit("Date Created")
        else
            exit("Document Date");
    end;


    procedure GetTableCaptionPlural(): Text[250]
    begin
    end;

    procedure LookupExternalPostingAccount(var Text: Text[1024]): Boolean
    begin
        Text := '';
    end;

    procedure IsCreditCardUserPaid(): Boolean
    begin
    end;

    procedure GetReimbursMethodForRecUsr(): Integer
    var
        DefaultUserSetup: Record "CEM Default User Setup";
    begin
        exit(DefaultUserSetup.GetExpReimbursMethodForUser("Continia User ID"));
    end;

    procedure ShowExpense()
    begin
    end;

    procedure ShouldHandleCASalesTax(): Boolean
    begin
    end;

    procedure GetRecordID(var RecID: RecordID)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        RecID := RecRef.RecordId;
        RecRef.Close();
    end;


    procedure GetPostingDescription(): Text[1024]
    var
        ExpPostingDescFields: Record "CEM Exp. Posting Desc. Field";
    begin
        exit(ExpPostingDescFields.GetPostingDesc(DATABASE::"CEM Expense", 0, '', "Entry No."));
    end;


    procedure FindSimilarExpense(var EntryNo: Integer): Boolean
    var
        Expense: Record "CEM Expense";
    begin
        Expense.Reset();
        Expense.SetCurrentKey("Continia User ID", "Document Date", "Currency Code", Amount);
        Expense.SetRange("Continia User ID", Rec."Continia User ID");
        Expense.SetRange("Document Date", Rec."Document Date");
        Expense.SetRange("Currency Code", Rec."Currency Code");
        Expense.SetRange(Amount, Rec.Amount);
        Expense.SetFilter("Entry No.", '<>%1', Rec."Entry No.");
        if Expense.FindFirst() then
            EntryNo := Expense."Entry No.";

        exit(EntryNo <> 0);
    end;


    procedure EmployeeReimbExpectedInBC(): Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        ExpenseAllocation: Record "CEM Expense Allocation";
        EMSetup: Record "CEM Expense Management Setup";
    begin
        if "Reimbursement Method" <> "Reimbursement Method"::"Vendor (on User)" then
            exit(false);

        // Cash Expenses will always be paid
        if "Cash/Private Card" then
            exit(true);

        // A payment will always be done if the credit card is privately invoiced
        if IsCreditCardUserPaid() then
            exit(true);

        // Only Non-refundable bank transactions will have to be paid
        if "Matched to Bank Transaction" then
            if AllocationExists() then begin
                ExpenseAllocation.SetCurrentKey("Expense Entry No.");
                ExpenseAllocation.SetRange("Expense Entry No.", "Entry No.");
                ExpenseAllocation.SetRange("No Refund", true);
                if not ExpenseAllocation.IsEmpty then
                    exit(true);
            end else
                if "No Refund" then
                    exit(true);

        // Only Non-refundable bank transactions will have to be paid. This expense will be posted as if matched.
        if "No Refund" then
            if (not EMSetup.IsMatchingRequiredOnDate("Document Date")) then begin
                ContiniaUserSetup.Get("Continia User ID");
                if ContiniaUserSetup."Corporate Credit Card" then
                    exit(true);
            end;
    end;


    procedure GetExternalDocNo(): Code[20]
    begin
    end;

    procedure CheckWarningLimitAndGetCmt(var CommentTxt: Text[250]): Boolean
    begin
    end;

    procedure CheckApproveBelowLimit(var LimitAmountLCY: Decimal): Boolean
    begin
    end;

    procedure GetExpBalanceOnUserForDateInt(StartDate: Date; EndDate: Date): Decimal
    begin
    end;

    procedure CheckRefundWithinLimit(var CompanyPolicy: Record "CEM Company Policy"): Boolean
    begin
    end;

    procedure CheckRefundWithinLimitAndAlloc()
    begin
    end;

    procedure UpdateAllocationsToLimitAmount()
    begin
    end;

    procedure GetRefundableAmount() RefundableAmtLCY: Decimal
    begin
    end;

    procedure CalcRefundableAmount(Amount: Decimal; PaidWithCorporateCreditCard: Boolean; NoRefund: Boolean) RefundableAmtLCY: Decimal
    begin
    end;

    procedure GetRfndableAmtFromFilteredExp(var Expense: Record "CEM Expense") RefundableAmtLCY: Decimal
    begin
    end;

    procedure GetEmployeeEmailDep(): Text[250]
    begin
    end;

    procedure IsExpenseRejected(): Boolean
    begin
    end;

    procedure ReopenExpenses(var Expense: Record "CEM Expense")
    begin
    end;

    procedure SkipLimitCalculation(SkipAllocationLimit: Boolean)
    begin
    end;

    procedure RecalculateAmounts(var BaseAmount: Decimal; var VATAmount: Decimal; var VATPercentage: Decimal)
    begin
    end;

    procedure StatusAllowsChange() Condition: Boolean
    begin
    end;

    procedure StatusOrUserAllowsChange() Condition: Boolean
    begin
    end;

    procedure TestStatusAllowsChange()
    begin
    end;

    procedure TestStatusOrUserAllowsChange()
    begin
    end;

    procedure NextApprover(): Code[50]
    begin
    end;

    procedure CurrentUserIsNextApprover(): Boolean
    begin
    end;
}