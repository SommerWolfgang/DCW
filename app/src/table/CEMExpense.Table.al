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
            TableRelation = "CDC Continia User Setup";

            trigger OnValidate()
            var
                UserDelegation: Record "CEM User Delegation";
                EmptyGuid: Guid;
            begin
                if "Settlement No." <> '' then
                    Error(CannotChangeWhenSttl, FieldCaption("Continia User ID"));

                if "Continia User ID" = xRec."Continia User ID" then
                    exit;

                UserDelegation.VerifyUser("Continia User ID");

                TestField(Status, Status::Open);
                TestField("Matched to Bank Transaction", false);
                CheckInboxAndThrowError;

                if not SupressAllocationsExist then
                    if AllocationExists then
                        Error(ExpenseAllocatedErr, FieldCaption("Continia User ID"));

                Validate("Reimbursement Method", GetReimbursMethodForRecUsr);

                if "Expense GUID" <> EmptyGuid then
                    "Expense GUID" := EmptyGuid;

                Validate("Expense Type");

                CalcFields("Continia User Name");

                AddDefaultDim(CurrFieldNo);
            end;
        }
        field(3; "Continia User Name"; Text[50])
        {
            CalcFormula = Lookup("CDC Continia User".Name WHERE("User ID" = FIELD("Continia User ID")));
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
            TableRelation = Currency;

            trigger OnValidate()
            begin
                TestStatusAllowsChange;
                UpdateAmount(FieldNo("Currency Code"));
                ExpValidate.Run(Rec);
            end;
        }
        field(10; "No Refund"; Boolean)
        {
            Caption = 'No Refund';

            trigger OnValidate()
            begin
                if "No Refund" <> xRec."No Refund" then
                    TestStatusAllowsChange;
            end;
        }
        field(11; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate()
            begin
                TestStatusAllowsChange;
                if not SupressAllocationsExist then
                    if AllocationExists then
                        Error(ExpenseAllocatedErr, FieldCaption(Amount));

                UpdateAmount(FieldNo(Amount));
            end;
        }
        field(12; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';

            trigger OnValidate()
            begin
                TestStatusAllowsChange;
                if AllocationExists then
                    Error(ExpenseAllocatedErr, FieldCaption("Amount (LCY)"));

                UpdateAmount(FieldNo("Amount (LCY)"));
            end;
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
            CalcFormula = Sum("CEM Expense Allocation"."Amount (LCY)" WHERE("Expense Entry No." = FIELD("Entry No.")));
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
                TestStatusAllowsChange;
                "VAT Amount" := Amount - "Amount w/o VAT";
            end;
        }
        field(29; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            Description = 'Obsolete';

            trigger OnValidate()
            begin
                TestStatusAllowsChange;
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
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

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
                    if AllocationExists then
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

            trigger OnValidate()
            begin
                ExpValidate.Run(Rec);
            end;
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
            CalcFormula = Exist("CEM Comment" WHERE("Table ID" = CONST(6086320),
                                                     "Document Type" = CONST(Budget),
                                                     "Document No." = CONST(''),
                                                     "Doc. Ref. No." = FIELD("Entry No.")));
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

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
            begin
                if xRec."Expense Account Type" <> "Expense Account Type" then
                    Clear("Expense Account");

                if "Expense Account Type" = "Expense Account Type"::Item then begin
                    EMSetup.Get;
                    if EMSetup."Expense Posting" <> EMSetup."Expense Posting"::"Preferable Purchase Invoice" then
                        Error(ItemRequiresPurchInv);
                end;

                if xRec."Expense Account Type" <> "Expense Account Type" then
                    ExpValidate.Run(Rec);
            end;
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
            CalcFormula = Max("CEM Reminder"."No." WHERE("Table ID" = CONST(6086320),
                                                          "Document Type" = CONST(Budget),
                                                          "Document No." = CONST(''),
                                                          "Doc. Ref. No." = FIELD("Entry No.")));
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
            TableRelation = "CEM Expense Type";

            trigger OnValidate()
            var
                ContiniaUserSetup: Record "CDC Continia User Setup";
                BankTransaction: Record "CEM Bank Transaction";
                EMSetup: Record "CEM Expense Management Setup";
                ExpenseType: Record "CEM Expense Type";
                ExpPostingSetup: Record "CEM Posting Setup";
                ValidPostingSetupFound: Boolean;
            begin
                if not ExpenseType.Get("Expense Type") then
                    Clear(ExpenseType);

                if not ExpenseType."Attendees Required" then begin
                    CalcFields("No. of Attendees");
                    if "No. of Attendees" <> 0 then
                        Error(ExpTypeAttNotAllowed, ExpenseType.TableCaption, ExpenseType.Code);
                end;

                Validate("No Refund", ExpenseType."No Refund");

                if not ContiniaUserSetup.Get("Continia User ID") then
                    Clear(ContiniaUserSetup);

                ValidPostingSetupFound := (ExpenseType.Code <> '') and
                  ExpPostingSetup.FindPostingSetup(DATABASE::"CEM Expense", "Expense Type", "Country/Region Code",
                    "Continia User ID", ContiniaUserSetup."Expense User Group", false);

                if ValidPostingSetupFound then begin
                    if ExpPostingSetup."Posting Account Type" = ExpPostingSetup."Posting Account Type"::Item then begin
                        EMSetup.Get;
                        if EMSetup."Expense Posting" <> EMSetup."Expense Posting"::"Preferable Purchase Invoice" then
                            Error(ItemRequiresPurchInv);
                    end;

                    "Expense Account Type" := ExpPostingSetup."Posting Account Type";
                    "Expense Account" := ExpPostingSetup."Posting Account No.";
                    "External Posting Account Type" := ExpPostingSetup."External Posting Account Type";
                    "External Posting Account No." := ExpPostingSetup."External Posting Account No.";
                    "Gen. Prod. Posting Group" := ExpPostingSetup."Gen. Prod. Posting Group";
                    "VAT Prod. Posting Group" := ExpPostingSetup."VAT Prod. Posting Group";
                    "Gen. Bus. Posting Group" := ExpPostingSetup."Gen. Bus. Posting Group";
                    "VAT Bus. Posting Group" := ExpPostingSetup."VAT Bus. Posting Group";
                    "Tax Group Code" := ExpPostingSetup."Tax Group Code";
                end else begin
                    "Expense Account Type" := "Expense Account Type"::" ";
                    "Expense Account" := '';
                    "External Posting Account Type" := "External Posting Account Type"::" ";
                    "External Posting Account No." := '';
                    "Gen. Prod. Posting Group" := '';
                    "VAT Prod. Posting Group" := '';
                    "Gen. Bus. Posting Group" := '';
                    "VAT Bus. Posting Group" := '';
                    "Tax Group Code" := '';
                end;

                "Exp. Account Manually Changed" := false;

                AddDefaultDim(CurrFieldNo);

                if Description = '' then
                    Description := ExpenseType.Description;

                if BankTransaction.Get(GetMatchingBankEntryNo) then begin
                    BankTransaction."Expense Type" := "Expense Type";
                    BankTransaction.Modify;
                end;

                OnExpenseTypeValidateBeforeExpValidation(ExpPostingSetup, ValidPostingSetupFound, Rec);
                ExpValidate.Run(Rec);
            end;
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
            CalcFormula = Count("CEM Attachment" WHERE("Table ID" = CONST(6086320),
                                                        "Document Type" = CONST(Budget),
                                                        "Document No." = FILTER(''),
                                                        "Doc. Ref. No." = FIELD("Entry No.")));
            Caption = 'Attachments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(270; "No. of Attendees"; Integer)
        {
            CalcFormula = Count("CEM Attendee" WHERE("Table ID" = CONST(6086320),
                                                      "Doc. Ref. No." = FIELD("Entry No.")));
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

            trigger OnValidate()
            var
                EMSetup: Record "CEM Expense Management Setup";
            begin
                if "External Posting Account Type" in ["External Posting Account Type"::"Lessor Pay Type",
                  "External Posting Account Type"::"Dataloen Pay Type"]
                then begin
                    EMSetup.Get;
                    if EMSetup."Expense Posting" = EMSetup."Expense Posting"::"Preferable Purchase Invoice" then
                        Error(PurchasePostingNotAllowed, EMSetup.TableCaption, EMSetup.FieldCaption("Expense Posting"),
                          Format(EMSetup."Expense Posting"), TableCaption, Format("External Posting Account Type"));
                end;

                if xRec."External Posting Account Type" <> "External Posting Account Type" then
                    "External Posting Account No." := '';

                ExpValidate.Run(Rec);
            end;
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
        EMSetup.Get;
        if CalledByFieldNo <> FieldNo("Bank Currency Code") then
            TestField("Matched to Bank Transaction", false);

        if "Document Date" = 0D then
            CurrencyDate := WorkDate
        else
            CurrencyDate := "Document Date";

        ExpenseCurrencyFactor := 1;
        AccountCurrencyFactor := 1;
        if "Currency Code" <> '' then begin
            ExpenseCurrencyFactor := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
            Currency.Get("Currency Code");
            Currency.CheckAmountRoundingPrecision;
        end else
            Currency.InitRoundingPrecision;

        if "Bank Currency Code" <> '' then begin
            AccountCurrencyFactor := CurrExchRate.ExchangeRate(CurrencyDate, "Bank Currency Code");
            BankAccCurrency.Get("Bank Currency Code");
            BankAccCurrency.CheckAmountRoundingPrecision;
        end else
            BankAccCurrency.InitRoundingPrecision;

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
        exit(EMReminder.NextReminderDate("Continia User ID", DATABASE::"CEM Expense", 0, "Settlement No.", "Entry No.", GetEarliestDate));
    end;

    procedure ShowReminders()
    begin
    end;


    procedure CalcMatchedAmount(): Decimal
    var
        Match: Record "CEM Expense Match";
        "Sum": Decimal;
    begin
        Sum := 0;
        Match.SetCurrentKey("Expense Entry No.");
        Match.SetRange("Expense Entry No.", "Entry No.");
        if Match.FindFirst then
            repeat
                Match.CalcFields("Transaction Amount");
                Sum += Match."Transaction Amount";
            until Match.Next = 0;

        exit(Sum);
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
            GLSetup.Get;
            if MatchedExpense."Currency Code" <> '' then
                CurrCode := MatchedExpense."Currency Code"
            else
                CurrCode := GLSetup."LCY Code";

            if not Confirm(MergeAmtDiffQuestion, true, CurrCode, MatchedExpense.Amount) then
                Error('');
        end;

        MatchedExpense.TestField(Posted, false);
        UnMatchedExpense.TestField(Posted, false);

        if MatchedExpense.AllocationExists then
            Error(UnableToMergeWithAllocErr, MatchedExpense."Entry No.");

        if UnMatchedExpense.AllocationExists then
            if (UnMatchedExpense."Currency Code" <> MatchedExpense."Currency Code") or
              (UnMatchedExpense.Amount <> MatchedExpense.Amount) or
              (UnMatchedExpense."Amount (LCY)" <> MatchedExpense."Amount (LCY)")
            then
                Error(UnableToMergeWithAllocErr, UnMatchedExpense."Entry No.");

        ExpenseMatch.SetRange("Expense Entry No.", MatchedExpense."Entry No.");
        if ExpenseMatch.FindSet then
            repeat
                NewExpenseMatch := ExpenseMatch;
                NewExpenseMatch."Expense Entry No." := UnMatchedExpense."Entry No.";
                NewExpenseMatch.Insert;
                ExpenseMatch.Delete;
            until ExpenseMatch.Next = 0;

        EMAttachment.SetCurrentKey("Table ID", "Document Type", "Document No.", "Doc. Ref. No.");
        EMAttachment.SetRange("Table ID", DATABASE::"CEM Expense");
        EMAttachment.SetRange("Document Type", 0);
        EMAttachment.SetRange("Document No.", '');
        EMAttachment.SetRange("Doc. Ref. No.", MatchedExpense."Entry No.");
        if EMAttachment.FindLast then
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

        CODEUNIT.Run(CODEUNIT::"CEM Expense-Validate", UnMatchedExpense);
    end;


    procedure HasExpenseComment(): Boolean
    begin
        CalcFields(Comment);
        exit(Comment);
    end;


    procedure HasErrorComment(ShowFirstError: Boolean; RunValidationChecks: Boolean): Boolean
    var
        EMCmtMgt: Codeunit "CEM Comment Mgt.";
    begin
        exit(EMCmtMgt.HasErrorComments(DATABASE::"CEM Expense", 0, "Settlement No.", "Entry No.", ShowFirstError, RunValidationChecks));
    end;


    procedure HasWarningComment(ShowFirstError: Boolean): Boolean
    var
        EMCmtMgt: Codeunit "CEM Comment Mgt.";
    begin
        exit(EMCmtMgt.HasWarningComments(DATABASE::"CEM Expense", 0, "Settlement No.", "Entry No.", ShowFirstError, true));
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
    var
        BankTransInbox: Record "CEM Bank Transaction Inbox";
        ExpenseInbox: Record "CEM Expense Inbox";
        ReleaseNotificationEntry: Record "CEM Release Notification Entry";
        UserDelegation: Record "CEM User Delegation";
        NAVversionMgt: Codeunit "CEM NAV-version Mgt.";
        TextMessage: Text[1024];
    begin

        if UserDelegation.GetDelegationFilter <> '' then
            exit;

        ExpenseInbox.SetFilter(Status, '<>%1', ExpenseInbox.Status::Accepted);
        if not ExpenseInbox.IsEmpty then
            TextMessage := StrSubstNo(OneOrMoreInboxError, ExpenseInbox.TableCaption);

        BankTransInbox.SetFilter(Status, '<>%1', BankTransInbox.Status::Accepted);
        BankTransInbox.SetRange("Exclude Entry", false);
        if not BankTransInbox.IsEmpty then begin
            if TextMessage <> '' then
                TextMessage := TextMessage + '\\';
            TextMessage := TextMessage + OneOrMoreBankTransError;
        end;

        if ReleaseNotificationEntry.CheckForUnprocessedEntries then begin
            if TextMessage <> '' then
                TextMessage := TextMessage + '\\';
            TextMessage := TextMessage + StrSubstNo(OneOrMoreInboxError, ReleaseNotificationEntry.TableCaption);
        end;

        if ReleaseNotificationEntry.CheckForUnprocessedHistEntries then
            NAVversionMgt.SendHistoryToCO(false);

        if TextMessage <> '' then
            Message(TextMessage + ProcessInboxAsapTxt);
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
    var
        EMDimMgt: Codeunit "CEM Dimension Mgt.";
    begin
        exit(EMDimMgt.LookupGlobalDim(Text, DimNo));
    end;


    procedure Navigate()
    var
        NavigateExpense: Codeunit "CEM Navigate Expense - Find";
    begin
        NavigateExpense.NavigateExpense(Rec);
    end;


    procedure SetSuspendInboxCheck(NewSuspend: Boolean)
    begin
        SuspendInboxCheck := NewSuspend;
    end;


    procedure PostingSetupChanged(var NewCalculatedAccount: Code[20]): Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        ExpensePostingSetup: Record "CEM Posting Setup";
    begin
        if "Exp. Account Manually Changed" then
            exit(false);

        if not ContiniaUserSetup.Get("Continia User ID") then
            exit(false);

        ExpensePostingSetup.FindPostingSetup(DATABASE::"CEM Expense", "Expense Type", "Country/Region Code",
          "Continia User ID", ContiniaUserSetup."Expense User Group", false);
        NewCalculatedAccount := ExpensePostingSetup."Posting Account No.";

        OnAfterNewCalculatedAccount(Rec, NewCalculatedAccount, ExpensePostingSetup);
        exit("Expense Account" <> NewCalculatedAccount);
    end;


    procedure ExistsInInbox(): Boolean
    var
        ExpenseInbox: Record "CEM Expense Inbox";
    begin
        ExpenseInbox.SetCurrentKey("Expense GUID");
        ExpenseInbox.SetRange("Expense GUID", "Expense GUID");
        ExpenseInbox.SetFilter(Status, '%1|%2', ExpenseInbox.Status::Pending, ExpenseInbox.Status::Error);
        if not ExpenseInbox.IsEmpty then
            exit(true);
    end;


    procedure CheckInboxAndThrowError()
    begin
        if not SuspendInboxCheck then
            if ExistsInInbox then
                ThrowInboxError;
    end;


    procedure ThrowInboxError()
    var
        ExpenseInbox: Record "CEM Expense Inbox";
    begin
        Error(EMInboxFoundErr, TableCaption, "Entry No.", ExpenseInbox.TableCaption);
    end;


    procedure BankIntegrationExists(): Boolean
    var
        BankAgreement: Record "CEM Bank Agreement";
    begin
        // Not used. Will be marked as obsolete
        exit(not BankAgreement.IsEmpty);
    end;


    procedure TransactionInboxEntriesExist(): Boolean
    var
        BankTransactionInbox: Record "CEM Bank Transaction Inbox";
    begin
        exit(not BankTransactionInbox.IsEmpty);
    end;


    procedure IsSyncRequired(): Boolean
    var
        ExpOnlineMgt: Codeunit "CEM Expense Online Mgt.";
    begin
        exit(ExpOnlineMgt.IsSyncRequired(Rec));
    end;


    procedure AddDefaultDim(ValidatedFieldNo: Integer)
    var
        ContiniaUser: Record "CDC Continia User Setup";
        EMDimMgt: Codeunit "CEM Dimension Mgt.";
    begin
        if "Entry No." = 0 then
            exit;

        DeleteOldDefaultDim;

        if ContiniaUser.Get("Continia User ID") then begin
            if ContiniaUser.GetSalesPurchCode <> '' then
                EMDimMgt.InsertDefaultDimExpense(DATABASE::"Salesperson/Purchaser", ContiniaUser.GetSalesPurchCode, Rec);

            if ContiniaUser."Vendor No." <> '' then
                EMDimMgt.InsertDefaultDimExpense(DATABASE::Vendor, ContiniaUser."Vendor No.", Rec);

            if ContiniaUser."Employee No." <> '' then;
            EMDimMgt.InsertDefaultDimExpense(DATABASE::Employee, ContiniaUser."Employee No.", Rec);
        end;

        if "Expense Account" <> '' then
            EMDimMgt.InsertDefaultDimExpense(DATABASE::"G/L Account", "Expense Account", Rec);

        if "Expense Type" <> '' then
            EMDimMgt.InsertDefaultDimExpense(DATABASE::"CEM Expense Type", "Expense Type", Rec);

        if "Job No." <> '' then
            EMDimMgt.InsertDefaultDimExpense(DATABASE::Job, "Job No.", Rec);

        if "Job Task No." <> '' then
            EMDimMgt.InsertDefaultDimExpense(DATABASE::"Job Task", "Job Task No.", Rec);

        case ValidatedFieldNo of
            FieldNo("Continia User ID"):
                if ContiniaUser.Get("Continia User ID") then begin
                    if ContiniaUser.GetSalesPurchCode <> '' then
                        EMDimMgt.InsertDefaultDimExpense(DATABASE::"Salesperson/Purchaser", ContiniaUser.GetSalesPurchCode, Rec);

                    if ContiniaUser."Vendor No." <> '' then
                        EMDimMgt.InsertDefaultDimExpense(DATABASE::Vendor, ContiniaUser."Vendor No.", Rec);

                    if ContiniaUser."Employee No." <> '' then;
                    EMDimMgt.InsertDefaultDimExpense(DATABASE::Employee, ContiniaUser."Employee No.", Rec);
                end;

            FieldNo("Expense Account"):
                if "Expense Account" <> '' then
                    EMDimMgt.InsertDefaultDimExpense(DATABASE::"G/L Account", "Expense Account", Rec);

            FieldNo("Expense Type"):
                if "Expense Type" <> '' then
                    EMDimMgt.InsertDefaultDimExpense(DATABASE::"CEM Expense Type", "Expense Type", Rec);

            FieldNo("Job No."):
                if "Job No." <> '' then
                    EMDimMgt.InsertDefaultDimExpense(DATABASE::Job, "Job No.", Rec);

            FieldNo("Job Task No."):
                if "Job Task No." <> '' then
                    EMDimMgt.InsertDefaultDimExpense(DATABASE::"Job Task", "Job Task No.", Rec);
        end;
    end;

    local procedure DeleteOldDefaultDim()
    var
        ContiniaUser: Record "CDC Continia User Setup";
        EMDimMgt: Codeunit "CEM Dimension Mgt.";
    begin
        if ContiniaUser.Get(xRec."Continia User ID") then begin
            if ContiniaUser.GetSalesPurchCode <> '' then
                EMDimMgt.DeleteDefaultDimExpense(DATABASE::"Salesperson/Purchaser", ContiniaUser.GetSalesPurchCode, Rec);

            if ContiniaUser."Vendor No." <> '' then
                EMDimMgt.DeleteDefaultDimExpense(DATABASE::Vendor, ContiniaUser."Vendor No.", Rec);

            if ContiniaUser."Employee No." <> '' then;
            EMDimMgt.DeleteDefaultDimExpense(DATABASE::Employee, ContiniaUser."Employee No.", Rec);
        end;

        if xRec."Expense Type" <> '' then
            EMDimMgt.DeleteDefaultDimExpense(DATABASE::"CEM Expense Type", xRec."Expense Type", Rec);

        if xRec."Expense Account" <> '' then
            EMDimMgt.DeleteDefaultDimExpense(DATABASE::"G/L Account", xRec."Expense Account", Rec);

        if xRec."Job No." <> '' then
            EMDimMgt.DeleteDefaultDimExpense(DATABASE::Job, xRec."Job No.", Rec);

        if xRec."Job Task No." <> '' then
            EMDimMgt.DeleteDefaultDimExpense(DATABASE::"Job Task", xRec."Job Task No.", Rec);
    end;


    procedure GetMatchingBankEntryNo(): Integer
    var
        ExpenseMatch: Record "CEM Expense Match";
    begin
        ExpenseMatch.SetRange("Expense Entry No.", "Entry No.");
        if ExpenseMatch.FindFirst then
            exit(ExpenseMatch."Transaction Entry No.");
    end;


    procedure GetAttendeesForDisplay() DisplayTxt: Text[150]
    var
        ExpAttendee: Record "CEM Attendee";
    begin
        exit(ExpAttendee.GetAttendeesForDisplay(DATABASE::"CEM Expense", "Entry No."));
    end;


    procedure DrillDownAttendees()
    var
        ExpAttendee: Record "CEM Attendee";
        TempExpAttendee: Record "CEM Attendee" temporary;
        ExpenseType: Record "CEM Expense Type";
        ExpAttendees: Page "CEM Expense Attendees";
    begin
        ExpAttendee.SetRange("Table ID", DATABASE::"CEM Expense");
        ExpAttendee.SetRange("Doc. Ref. No.", "Entry No.");

        TestField("Expense Type");
        ExpenseType.Get("Expense Type");
        if not ExpenseType."Attendees Required" then
            Error(ExpTypeAttNotReq, ExpenseType.TableCaption, ExpenseType.Code);

        TempExpAttendee.DeleteAll;
        if not Posted then begin
            if ExpAttendee.FindSet then
                repeat
                    TempExpAttendee := ExpAttendee;
                    TempExpAttendee.Insert;
                until ExpAttendee.Next = 0;

            TempExpAttendee.SetRange("Table ID", DATABASE::"CEM Expense");
            TempExpAttendee.SetRange("Doc. Ref. No.", "Entry No.");
            PAGE.RunModal(0, TempExpAttendee);
            if TempExpAttendee.AttendeesUpdated(TempExpAttendee, "Entry No.", DATABASE::"CEM Expense") then begin
                ExpAttendee.DeleteAll;

                if TempExpAttendee.FindSet then
                    repeat
                        ExpAttendee := TempExpAttendee;
                        ExpAttendee.Insert;
                    until TempExpAttendee.Next = 0;

                SendToExpenseUser;
                CODEUNIT.Run(CODEUNIT::"CEM Expense-Validate", Rec);
            end;
        end else begin
            ExpAttendees.SetTableView(ExpAttendee);
            ExpAttendees.Editable := false;
            ExpAttendees.RunModal;
        end;
    end;


    procedure SendToExpenseUser()
    var
        SendToExpUser: Codeunit "CEM Expense - Send to User";
    begin
        if SkipSendToExpUser then
            exit;

        if Status = Status::"Pending Expense User" then
            SendToExpUser.UpdateWithoutFiles(Rec);
    end;


    procedure LookupDimensions(Editable: Boolean)
    var
        Expense: Record "CEM Expense";
    begin
        if Expense.Get("Entry No.") then
            DrillDownDimensions(PAGE::"CEM Dimensions", Editable);
    end;


    procedure LookupExtraFields(Editable: Boolean)
    var
        Expense: Record "CEM Expense";
    begin
        if Expense.Get("Entry No.") then
            DrillDownDimensions(PAGE::"CEM Extra Fields", Editable);
    end;

    local procedure DrillDownDimensions(FormID: Integer; Editable: Boolean)
    var
        EMDim: Record "CEM Dimension";
        TempEMDim: Record "CEM Dimension" temporary;
        ExpDim: Page "CEM Dimensions";
        ExpExtraFields: Page "CEM Extra Fields";
    begin
        EMDim.SetRange("Table ID", DATABASE::"CEM Expense");
        EMDim.SetRange("Document Type", 0);
        EMDim.SetRange("Document No.", '');
        EMDim.SetRange("Doc. Ref. No.", "Entry No.");

        if (not Posted) and StatusOrUserAllowsChange and Editable then begin
            if EMDim.FindSet then
                repeat
                    TempEMDim := EMDim;
                    TempEMDim.Insert;
                until EMDim.Next = 0;

            TempEMDim.SetRange("Table ID", DATABASE::"CEM Expense");
            TempEMDim.SetRange("Document Type", 0);
            TempEMDim.SetRange("Document No.", '');
            TempEMDim.SetRange("Doc. Ref. No.", "Entry No.");
            PAGE.RunModal(FormID, TempEMDim);

            if EMDim.EMDimUpdated(TempEMDim, DATABASE::"CEM Expense", 0, '', "Entry No.") then begin
                EMDim.DeleteAll(true);

                if TempEMDim.FindSet then
                    repeat
                        EMDim := TempEMDim;
                        EMDim.Insert(true);
                    until TempEMDim.Next = 0;

                Get("Entry No.");
                SendToExpenseUser;

                CODEUNIT.Run(CODEUNIT::"CEM Expense-Validate", Rec);
            end;
        end else
            case FormID of
                PAGE::"CEM Dimensions":
                    begin
                        ExpDim.SetTableView(EMDim);
                        ExpDim.SetReadOnly;
                        ExpDim.RunModal;
                    end;

                PAGE::"CEM Extra Fields":
                    begin
                        ExpExtraFields.SetTableView(EMDim);
                        ExpExtraFields.SetReadOnly;
                        ExpExtraFields.RunModal;
                    end;
            end;
    end;


    procedure ShowAttachments()
    var
        EMAttachment: Record "CEM Attachment";
    begin
        EMAttachment.SetRange("Table ID", DATABASE::"CEM Expense");
        EMAttachment.SetRange("Document Type", 0);
        EMAttachment.SetRange("Document No.", '');
        EMAttachment.SetRange("Doc. Ref. No.", "Entry No.");
        PAGE.RunModal(0, EMAttachment);
    end;


    procedure GetOverviewDetails() AddInfo: Text[250]
    var
        ExpenseAllocation: Record "CEM Expense Allocation";
    begin
        AddTextTo(AddInfo, GetAttendeesForDisplay);

        if "No Refund" then
            AddTextTo(AddInfo, FieldCaption("No Refund"));

        ExpenseAllocation.SetCurrentKey("Expense Entry No.");
        ExpenseAllocation.SetRange("Expense Entry No.", "Entry No.");
        if not ExpenseAllocation.IsEmpty then
            AddTextTo(AddInfo, AllocatedTxt);

        if "Cash/Private Card" then
            AddTextTo(AddInfo, FieldCaption("Cash/Private Card"));

        if (not "Cash/Private Card") and (not "Matched to Bank Transaction") then
            AddTextTo(AddInfo, MissingBankTransTxt);
    end;

    local procedure AddTextTo(var ReturnTxt: Text[250]; TxtToAdd: Text[250])
    begin
        if TxtToAdd = '' then
            exit;

        if (StrLen(TxtToAdd) + StrLen(ReturnTxt)) > MaxStrLen(ReturnTxt) then
            exit;

        if ReturnTxt = '' then
            ReturnTxt := TxtToAdd
        else
            ReturnTxt := ReturnTxt + ',' + TxtToAdd;
    end;


    procedure GetNextDocumentLineNo() LineNo: Integer
    var
        Expense: Record "CEM Expense";
    begin
        Expense.SetCurrentKey("Settlement No.");
        Expense.SetRange("Settlement No.", "Settlement No.");
        Expense.SetFilter("Entry No.", '<>%1', "Entry No.");
        if Expense.FindLast then
            exit(Expense."Settlement Line No." + 10000);

        exit(10000);
    end;


    procedure OpenDocumentCard()
    var
        Settlement: Record "CEM Expense Header";
        ExpenseCard: Page "CEM Expense Card";
        PostedExpenseCard: Page "CEM Posted Expense Card";
    begin
        if Settlement.Get(Settlement."Document Type"::Settlement, "Settlement No.") then
            Settlement.OpenDocumentCard
        else
            if Posted then begin
                PostedExpenseCard.SetRecord(Rec);
                PostedExpenseCard.LockToSpecificDocumentNo("Entry No.");
                PostedExpenseCard.Run;
            end else begin
                ExpenseCard.SetRecord(Rec);
                ExpenseCard.LockToSpecificDocumentNo("Entry No.");
                ExpenseCard.Run;
            end;
    end;


    procedure SplitAndAllocate()
    var
        ExpenseAlloc: Record "CEM Expense Allocation";
        Spliform: Page "CEM Expense Split and Alloc.";
    begin
        ExpenseAlloc.SetRange("Expense Entry No.", "Entry No.");
        Spliform.SetTableView(ExpenseAlloc);
        Spliform.RunModal;
    end;


    procedure LookupComments()
    var
        EMCmtMgt: Codeunit "CEM Comment Mgt.";
    begin
        EMCmtMgt.LookupComments(DATABASE::"CEM Expense", 0, '', "Entry No.");
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
            Expense.FindFirst;
            repeat
                Expense2.Get(Expense."Entry No.");
                Expense2.Validate("Settlement No.", '');
                Expense2.Modify(true);
            until Expense.Next = 0;
        end;
    end;


    procedure AttachExpenseToSettlement(var Expense: Record "CEM Expense")
    var
        Expense2: Record "CEM Expense";
        ExpHeader: Record "CEM Expense Header";
    begin
        if Expense.Count = 0 then
            Error(NoExpInSelection);

        Expense.FindFirst;

        ExpHeader.FilterGroup(4);
        ExpHeader.SetRange("Continia User ID", Expense."Continia User ID");
        ExpHeader.SetFilter(Status, '%1|%2', ExpHeader.Status::Open, ExpHeader.Status::"Pending Expense User");
        ExpHeader.FilterGroup(0);
        if PAGE.RunModal(PAGE::"CEM Settlement List", ExpHeader) = ACTION::LookupOK then
            repeat
                Expense.TestStatusAllowsChange;
                Expense2.Get(Expense."Entry No.");
                Expense2.Validate("Settlement No.", ExpHeader."No.");
                Expense2.Modify(true);
            until Expense.Next = 0;
    end;


    procedure LookupPostingAccount(var Text: Text[1024]): Boolean
    var
        GLAcc: Record "G/L Account";
        Item: Record Item;
    begin
        TestField("Expense Account Type");
        case "Expense Account Type" of
            "Expense Account Type"::"G/L Account":
                begin
                    if GLAcc.Get(Text) then;
                    if PAGE.RunModal(0, GLAcc) = ACTION::LookupOK then begin
                        Text := GLAcc."No.";
                        exit(true);
                    end;
                end;

            "Expense Account Type"::Item:
                begin
                    if Item.Get(Text) then;
                    if PAGE.RunModal(0, Item) = ACTION::LookupOK then begin
                        Text := Item."No.";
                        exit(true);
                    end;
                end;
        end;
    end;


    procedure GetEntryNo(): Integer
    var
        Expense: Record "CEM Expense";
    begin
        if Expense.FindLast then
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
        exit(ExpensePlural);
    end;


    procedure LookupExternalPostingAccount(var Text: Text[1024]): Boolean
    var
        DataloenIntegration: Codeunit "CEM Dataloen Integration";
        LessorIntegration: Codeunit "CEM Lessor Integration";
    begin
        TestField("External Posting Account Type");
        case "External Posting Account Type" of
            "External Posting Account Type"::"Lessor Pay Type":
                exit(LessorIntegration.LookupPayType(Text));

            "External Posting Account Type"::"Dataloen Pay Type":
                exit(DataloenIntegration.LookupPayType(Text));
        end;
    end;


    procedure IsCreditCardUserPaid(): Boolean
    var
        BankTransaction: Record "CEM Bank Transaction";
    begin
        if not "Matched to Bank Transaction" then
            exit;

        if BankTransaction.Get(GetMatchingBankEntryNo) then
            exit(BankTransaction."User Paid Credit Card");
    end;


    procedure GetReimbursMethodForRecUsr(): Integer
    var
        DefaultUserSetup: Record "CEM Default User Setup";
    begin
        exit(DefaultUserSetup.GetExpReimbursMethodForUser("Continia User ID"));
    end;


    procedure ShowExpense()
    var
        ExpHeader: Record "CEM Expense Header";
    begin
        // Deprecated

        if ExpHeader.Get(ExpHeader."Document Type"::Settlement, Rec."Settlement No.") then
            if ExpHeader.Posted then
                PAGE.RunModal(PAGE::"CEM Posted Settlement Card", ExpHeader)
            else
                PAGE.RunModal(PAGE::"CEM Settlement Card", ExpHeader)
        else
            if Posted then
                PAGE.RunModal(PAGE::"CEM Posted Expense Card", Rec)
            else
                PAGE.RunModal(PAGE::"CEM Expense Card", Rec);
    end;


    procedure ShouldHandleCASalesTax(): Boolean
    var
        SalesTaxInterface: Codeunit "CEM Sales Tax Interface";
    begin
        // Control fields visibility inside EM
        // In this way the users cannot add the irrelevant fields in other localizations
        exit(SalesTaxInterface.ShouldHandleCASalesTax);
    end;


    procedure GetRecordID(var RecID: RecordID)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        RecID := RecRef.RecordId;
        RecRef.Close;
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
        Expense.Reset;
        Expense.SetCurrentKey("Continia User ID", "Document Date", "Currency Code", Amount);
        Expense.SetRange("Continia User ID", Rec."Continia User ID");
        Expense.SetRange("Document Date", Rec."Document Date");
        Expense.SetRange("Currency Code", Rec."Currency Code");
        Expense.SetRange(Amount, Rec.Amount);
        Expense.SetFilter("Entry No.", '<>%1', Rec."Entry No.");
        if Expense.FindFirst then
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
        if IsCreditCardUserPaid then
            exit(true);

        // Only Non-refundable bank transactions will have to be paid
        if "Matched to Bank Transaction" then
            if AllocationExists then begin
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
        exit(StrSubstNo('%1 %2', TableCaption, Format("Entry No.")));
    end;


    procedure CheckWarningLimitAndGetCmt(var CommentTxt: Text[250]): Boolean
    var
        CompanyPolicy: Record "CEM Company Policy";
    begin
        if not CompanyPolicy.GetWarningCommentPolicy(DATABASE::"CEM Expense", "Continia User ID", "Expense Type") then
            exit;

        exit(CheckLimitAndGetCmt(CompanyPolicy, CommentTxt));
    end;

    local procedure CheckLimitAndGetCmt(CompanyPolicy: Record "CEM Company Policy"; var CommentTxt: Text[250]): Boolean
    var
        GLSetup: Record "General Ledger Setup";
        TimeSpecified: Boolean;
        EndDate: Date;
        StartDate: Date;
    begin
        CompanyPolicy.GetTimeIntervalStartAndEndDate("Document Date", StartDate, EndDate);

        if GetExpBalanceOnUserForDateInt(StartDate, EndDate) > CompanyPolicy."Amount (LCY)" then begin
            GLSetup.Get;
            TimeSpecified := CompanyPolicy."Period of Time" <> CompanyPolicy."Period of Time"::" ";

            // Limits on Expense Level
            if (CompanyPolicy."Document Type" <> CompanyPolicy."Document Type"::" ") and
              (CompanyPolicy."Document Account No." = '') then begin
                if TimeSpecified then
                    CommentTxt := StrSubstNo(ExpenseLimitTimedTxt, CompanyPolicy."Amount (LCY)",
                      GLSetup."LCY Code", LowerCase(Format(CompanyPolicy."Period of Time")))
                else
                    CommentTxt := StrSubstNo(ExpenseLimitTxt, CompanyPolicy."Amount (LCY)", GLSetup."LCY Code");

                exit(true);
            end;

            // Limits on an Expense Type level
            if (CompanyPolicy."Document Type" <> CompanyPolicy."Document Type"::" ") and
              (CompanyPolicy."Document Account No." <> '') then begin
                if TimeSpecified then
                    CommentTxt := StrSubstNo(ExpTypeLimitTimedTxt, "Expense Type", CompanyPolicy."Amount (LCY)",
                      GLSetup."LCY Code", LowerCase(Format(CompanyPolicy."Period of Time")))
                else
                    CommentTxt := StrSubstNo(ExpTypeLimitTxt, "Expense Type", CompanyPolicy."Amount (LCY)",
                      GLSetup."LCY Code");

                exit(true);
            end;
        end;
    end;


    procedure CheckApproveBelowLimit(var LimitAmountLCY: Decimal): Boolean
    var
        CompanyPolicy: Record "CEM Company Policy";
        GLSetup: Record "General Ledger Setup";
        EndDate: Date;
        StartDate: Date;
    begin
        if not CompanyPolicy.GetApproveBelowPolicy(DATABASE::"CEM Expense", "Continia User ID", "Expense Type") then
            exit(false);

        CompanyPolicy.GetTimeIntervalStartAndEndDate("Document Date", StartDate, EndDate);
        LimitAmountLCY := CompanyPolicy."Amount (LCY)";
        exit(GetExpBalanceOnUserForDateInt(StartDate, EndDate) <= CompanyPolicy."Amount (LCY)");
    end;


    procedure GetExpBalanceOnUserForDateInt(StartDate: Date; EndDate: Date): Decimal
    var
        Expense: Record "CEM Expense";
    begin
        if (StartDate <> 0D) and (EndDate <> 0D) then begin
            Expense.SetCurrentKey("Continia User ID", "Document Date", "Expense Type");
            Expense.SetRange("Continia User ID", Rec."Continia User ID");
            Expense.SetRange("Document Date", StartDate, EndDate);
            Expense.SetRange("Expense Type", "Expense Type");
            Expense.SetFilter("Entry No.", '<>%1', Rec."Entry No."); // Exclude current (potentially) un-commited rec.
            Expense.CalcSums("Amount (LCY)");
            exit(Expense."Amount (LCY)" + Rec."Amount (LCY)"); //Add Current Rec Amount
        end else
            exit(Rec."Amount (LCY)");
    end;


    procedure CheckRefundWithinLimit(var CompanyPolicy: Record "CEM Company Policy"): Boolean
    var
        ExpAllocation: Record "CEM Expense Allocation";
        ExpTypeUniqueTemp: Record "CEM Expense Type" temporary;
    begin
        if not AllocationExists then begin
            if CompanyPolicy.GetRefundWithinPolicy(DATABASE::"CEM Expense", "Continia User ID", "Expense Type") then
                if "Amount (LCY)" > CompanyPolicy."Amount (LCY)" then
                    exit(true);
        end else begin
            // Load unique expense types in buffer
            ExpAllocation.SetRange("Expense Entry No.", "Entry No.");
            ExpAllocation.SetRange("No Refund", false);
            if ExpAllocation.FindSet then
                repeat
                    ExpTypeUniqueTemp.Code := ExpAllocation."Expense Type";
                    if not ExpTypeUniqueTemp.Insert then;
                until ExpAllocation.Next = 0;

            if ExpTypeUniqueTemp.FindSet then
                repeat
                    if CompanyPolicy.GetRefundWithinPolicy(DATABASE::"CEM Expense", "Continia User ID", "Expense Type") then begin
                        ExpAllocation.SetRange("Expense Entry No.", "Entry No.");
                        ExpAllocation.SetRange("No Refund", false);
                        ExpAllocation.SetRange("Expense Type", ExpTypeUniqueTemp.Code);
                        ExpAllocation.CalcSums("Amount (LCY)");

                        if ExpAllocation."Amount (LCY)" >= CompanyPolicy."Amount (LCY)" then
                            exit(true);
                    end;
                until ExpTypeUniqueTemp.Next = 0;
        end;
    end;


    procedure CheckRefundWithinLimitAndAlloc()
    begin
        if not AllocationExists then
            AllocateCurrExpToLimitAmt
        else
            UpdateAllocationsToLimitAmount;
    end;

    local procedure AllocateCurrExpToLimitAmt()
    var
        EMComment: Record "CEM Comment";
        CompanyPolicy: Record "CEM Company Policy";
        ExpAllocation: Record "CEM Expense Allocation";
        NewExpAllocation: Record "CEM Expense Allocation";
        ExpType: Record "CEM Expense Type";
        GLSetup: Record "General Ledger Setup";
        AllocationMgt: Codeunit "CEM Split and Allocation Mgt.";
        MainAllocationEntryNo: Integer;
    begin
        if not CompanyPolicy.GetRefundWithinPolicy(DATABASE::"CEM Expense", "Continia User ID", "Expense Type") then
            exit;

        if CompanyPolicy."Amount (LCY)" >= "Amount (LCY)" then
            exit;

        if "No Refund" then
            exit;

        // Create a new allocation with the limit amount
        // This allocation has to be the first one, event though we don't know the amount yet.
        // Please don't validate the "Amount %". That will be wrong when adjusting decimals.
        NewExpAllocation.TransferFields(Rec);
        NewExpAllocation."Expense Entry No." := "Entry No.";
        NewExpAllocation."Entry No." := 0;
        NewExpAllocation.SetExpense(Rec); // Rec is not yet commited
        NewExpAllocation.SetSkipSendToUser(true); // It will be sent later, when all the allocations are changed.
        NewExpAllocation.Insert(true);
        MainAllocationEntryNo := NewExpAllocation."Entry No.";

        // Create an allocation with the limit amount
        Clear(NewExpAllocation);
        NewExpAllocation.TransferFields(Rec);
        NewExpAllocation."Entry No." := 0;
        NewExpAllocation."Expense Entry No." := "Entry No.";
        NewExpAllocation.SetExpense(Rec); // Rec is not yet commited
        NewExpAllocation.Validate("Amount (LCY)", CompanyPolicy."Amount (LCY)");

        NewExpAllocation.SetSkipSendToUser(true); // It will be sent later, when all the allocations are changed.
        NewExpAllocation.Insert(true);

        // Adjust the Amount on the Initial allocation.
        // It is important to happen after the initial allocation because  then it handles decimal differences.
        ExpAllocation.Get(MainAllocationEntryNo);
        ExpAllocation.SetExpense(Rec); // Rec is not yet commited
        ExpAllocation.Validate(Amount, Amount - NewExpAllocation.Amount);
        if ExpType.GetNonRefundableExpType <> '' then
            ExpAllocation.Validate("Expense Type", ExpType.GetNonRefundableExpType);
        ExpAllocation.Validate("No Refund", true);
        ExpAllocation."Limit allocation" := true;
        ExpAllocation.SetSkipSendToUser(true); // It will be sent later, when all the allocations are changed.
        ExpAllocation.Modify(true); // Will be marked as modified and not automatically deleted

        ExpAllocation.AdjustAmtsToDecAndRecalc;

        GLSetup.Get;
        AllocationMgt.InsertPolicyAllocationComment("Entry No.", StrSubstNo(ExpAutoAllocateTxt, "Expense Type", Format(CompanyPolicy."Amount (LCY)"), GLSetup."LCY Code"));

        // Delete the comment that says that the expense was allocated.
        AllocationMgt.RemoveAllocationComment("Entry No.");
    end;


    procedure UpdateAllocationsToLimitAmount()
    var
        ExpAllocation: Record "CEM Expense Allocation";
        ExpTypeUniqueTemp: Record "CEM Expense Type" temporary;
    begin
        ExpAllocation.SetRange("Expense Entry No.", "Entry No.");
        ExpAllocation.SetRange("No Refund", false);
        if ExpAllocation.FindSet then
            repeat
                ExpTypeUniqueTemp.Code := ExpAllocation."Expense Type";
                if not ExpTypeUniqueTemp.Insert then;
            until ExpAllocation.Next = 0;

        if ExpTypeUniqueTemp.FindSet then
            repeat
                UpdateAllocationsToExpTypeLmt(ExpTypeUniqueTemp.Code);
            until ExpTypeUniqueTemp.Next = 0;
    end;

    local procedure UpdateAllocationsToExpTypeLmt(ExpenseType: Code[20])
    var
        EMComment: Record "CEM Comment";
        CompanyPolicy: Record "CEM Company Policy";
        ExpAllocation: Record "CEM Expense Allocation";
        NewExpAllocation: Record "CEM Expense Allocation";
        ExpType: Record "CEM Expense Type";
        GLSetup: Record "General Ledger Setup";
        AllocationMgt: Codeunit "CEM Split and Allocation Mgt.";
        MaxRefundableAmount: Decimal;
        RefundableAmount: Decimal;
        MainAllocationEntryNo: Integer;
    begin
        if not CompanyPolicy.GetRefundWithinPolicy(DATABASE::"CEM Expense", "Continia User ID", ExpenseType) then
            exit;

        MaxRefundableAmount := CompanyPolicy."Amount (LCY)";

        if MaxRefundableAmount <= 0 then
            exit;

        ExpAllocation.SetRange("Expense Entry No.", "Entry No.");
        ExpAllocation.SetRange("No Refund", false);
        ExpAllocation.SetRange("Expense Type", ExpenseType);
        ExpAllocation.CalcSums("Amount (LCY)");

        if MaxRefundableAmount >= ExpAllocation."Amount (LCY)" then
            exit;

        ExpAllocation.SetRange("Expense Entry No.", "Entry No.");
        ExpAllocation.SetRange("Expense Type", ExpenseType);
        ExpAllocation.SetRange("No Refund", false);
        if ExpAllocation.FindSet then
            repeat
                RefundableAmount := RefundableAmount + ExpAllocation."Amount (LCY)";

                if RefundableAmount > MaxRefundableAmount then begin
                    if ExpAllocation."Amount (LCY)" = (RefundableAmount - MaxRefundableAmount) then begin
                        // Avoid splitting into 0 amount. Just mark the whole allocation as Non Refundable.
                        ExpAllocation.SetExpense(Rec); // Rec is not yet commited
                        if ExpType.GetNonRefundableExpType <> '' then
                            ExpAllocation.Validate("Expense Type", ExpType.GetNonRefundableExpType);
                        ExpAllocation.Validate("No Refund", true);
                        ExpAllocation."Limit allocation" := true;
                        ExpAllocation.Modify;
                    end else begin
                        // Create a new allocation based on the previous allocation
                        NewExpAllocation.Copy(ExpAllocation);
                        NewExpAllocation."Entry No." := 0;
                        NewExpAllocation.SetExpense(Rec); // Rec is not yet commited
                        NewExpAllocation.Validate("Amount (LCY)", RefundableAmount - MaxRefundableAmount);
                        if ExpType.GetNonRefundableExpType <> '' then
                            NewExpAllocation.Validate("Expense Type", ExpType.GetNonRefundableExpType);
                        NewExpAllocation.Validate("No Refund", true);
                        NewExpAllocation."Limit allocation" := true;
                        NewExpAllocation.SetSkipSendToUser(true); // It will be sent later, when all the allocations are changed.
                        NewExpAllocation.Insert(true);

                        // Lower the amount on the initial allocation
                        ExpAllocation.SetExpense(Rec); // Rec is not yet commited
                        ExpAllocation.Validate(Amount, ExpAllocation.Amount - NewExpAllocation.Amount);
                        ExpAllocation.Modify;

                        ExpAllocation.AdjustAmtsToDecAndRecalc;
                        ExpAllocation.Modify(true); // Will be marked as modified and not automatically deleted

                        RefundableAmount := MaxRefundableAmount;
                    end;
                end;
            until ExpAllocation.Next = 0;

        GLSetup.Get;
        AllocationMgt.InsertPolicyAllocationComment("Entry No.", StrSubstNo(ExpAutoAllocateTxt, "Expense Type", Format(CompanyPolicy."Amount (LCY)"), GLSetup."LCY Code"));

        // Delete the comment that says that the expense was allocated.
        AllocationMgt.RemoveAllocationComment("Entry No.");
    end;


    procedure GetRefundableAmount() RefundableAmtLCY: Decimal
    var
        ExpenseAllocation: Record "CEM Expense Allocation";
        EMSetup: Record "CEM Expense Management Setup";
        BankTransaction: Boolean;
        MatchingRequired: Boolean;
        PaidWithCompanyCreditCard: Boolean;
    begin
        if not EMSetup.Get then
            exit;

        MatchingRequired := EMSetup.IsMatchingRequiredOnDate("Document Date");
        PaidWithCompanyCreditCard := ("Matched to Bank Transaction" and not IsCreditCardUserPaid) or
          (not MatchingRequired and not "Cash/Private Card");

        if not AllocationExists then
            RefundableAmtLCY += CalcRefundableAmount("Amount (LCY)", PaidWithCompanyCreditCard, "No Refund")
        else begin
            ExpenseAllocation.SetCurrentKey("Expense Entry No.");
            ExpenseAllocation.SetRange("Expense Entry No.", "Entry No.");
            if ExpenseAllocation.FindSet then
                repeat
                    RefundableAmtLCY += CalcRefundableAmount(ExpenseAllocation."Amount (LCY)", PaidWithCompanyCreditCard, ExpenseAllocation."No Refund");
                until ExpenseAllocation.Next = 0;
        end;
    end;


    procedure CalcRefundableAmount(Amount: Decimal; PaidWithCorporateCreditCard: Boolean; NoRefund: Boolean) RefundableAmtLCY: Decimal
    begin
        case PaidWithCorporateCreditCard of
            true:
                if NoRefund then
                    exit(-Amount)
                else
                    exit(0); // Paid with corporate credit card. It is implicitly refunded.
            false:
                if NoRefund then
                    exit(0)
                else
                    exit(Amount);
        end;
    end;


    procedure GetRfndableAmtFromFilteredExp(var Expense: Record "CEM Expense") RefundableAmtLCY: Decimal
    begin
        if Expense.FindSet then
            repeat
                RefundableAmtLCY += Expense.GetRefundableAmount;
            until Expense.Next = 0;
    end;


    procedure GetEmployeeEmailDep(): Text[250]
    begin
    end;


    procedure IsExpenseRejected(): Boolean
    var
        ExpenseAllocation: Record "CEM Expense Allocation";
    begin
        // Rejected is just a state in CO. An expense is considered Rejected when "No Refund" is marked.
        if AllocationExists then begin
            ExpenseAllocation.SetCurrentKey("Expense Entry No.");
            ExpenseAllocation.SetRange("Expense Entry No.", "Entry No.");
            ExpenseAllocation.SetRange("No Refund", false);
            exit(ExpenseAllocation.IsEmpty);
        end else
            exit("No Refund");
    end;


    procedure ReopenExpenses(var Expense: Record "CEM Expense")
    var
        Expense2: Record "CEM Expense";
        PendingExpUserFound: Boolean;
        Question: Text[1024];
    begin
        // Do we have pending expense user records?
        Expense.SetRange(Status, Expense.Status::"Pending Expense User");
        PendingExpUserFound := not Expense.IsEmpty;
        Expense.SetRange(Status);

        if Expense.Count = 1 then begin
            if PendingExpUserFound then
                Question := ReopenSinglePendExpUsrQst
            else
                Question := ReopenSingleQst;
        end else
            if PendingExpUserFound then
                Question := StrSubstNo(ReopenMultiplePendExpUsrQst, Expense.Count)
            else
                Question := StrSubstNo(ReopenMultipleQst, Expense.Count);

        if not Confirm(Question, true) then
            exit;

        if Expense.FindSet(true, false) then
            repeat
                Expense2 := Expense;
                CODEUNIT.Run(CODEUNIT::"CEM Expense - Complete", Expense2);
            until Expense.Next = 0;
    end;


    procedure SkipLimitCalculation(SkipAllocationLimit: Boolean)
    begin
        SkipCheckRefundWithinLimitAndAlloc := SkipAllocationLimit;
    end;


    procedure RecalculateAmounts(var BaseAmount: Decimal; var VATAmount: Decimal; var VATPercentage: Decimal)
    var
        ExpenseTemp: Record "CEM Expense" temporary;
        ExpenseAllocation: Record "CEM Expense Allocation";
        ExpenseAllocationTemp: Record "CEM Expense Allocation" temporary;
        Currency: Record Currency;
        GLAccount: Record "G/L Account";
        VATPostingSetup: Record "VAT Posting Setup";
        BaseAmoutAllocation: Decimal;
        VATAmountAllocation: Decimal;
        VATPercentageAllocation: Decimal;
    begin
        ExpenseAllocationTemp.DeleteAll;

        BaseAmount := 0;
        VATAmount := 0;
        VATPercentage := 0;

        if AllocationExists then begin
            ExpenseAllocation.SetRange("Expense Entry No.", "Entry No.");
            if ExpenseAllocation.FindSet then
                repeat
                    ExpenseAllocationTemp := ExpenseAllocation;
                    ExpenseAllocationTemp.Insert;
                until ExpenseAllocation.Next = 0;
        end else begin
            ExpenseAllocationTemp.TransferFields(Rec);
            ExpenseAllocationTemp.Insert;
        end;

        if ExpenseAllocationTemp.FindSet then
            repeat
                ExpenseAllocationTemp.RecalculateAmounts(BaseAmoutAllocation, VATAmountAllocation, VATPercentageAllocation);
                BaseAmount += BaseAmoutAllocation;
                VATAmount += VATAmountAllocation;
                VATPercentage := VATPercentageAllocation;
            until ExpenseAllocationTemp.Next = 0;

        if AllocationExists then
            VATPercentage := 0;
    end;


    procedure StatusAllowsChange() Condition: Boolean
    begin
        Condition := Status in [Status::Open, Status::"Pending Expense User"];
    end;


    procedure StatusOrUserAllowsChange() Condition: Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        Condition := StatusAllowsChange or ContiniaUserSetup.CanEditApprovedDocuments(UserId);
    end;


    procedure TestStatusAllowsChange()
    begin
        if not StatusAllowsChange then
            Error(StatusNotAllowed, TableCaption, "Entry No.");
    end;


    procedure TestStatusOrUserAllowsChange()
    begin
        if not StatusOrUserAllowsChange then
            Error(StatusNotAllowed, TableCaption, "Entry No.");
    end;


    procedure NextApprover(): Code[50]
    var
        ApprovalMgt: Codeunit "CEM Approval Management";
    begin
        exit(ApprovalMgt.GetNextApprover(DATABASE::"CEM Expense", Format("Entry No.")));
    end;


    procedure CurrentUserIsNextApprover(): Boolean
    begin
        exit(UserId = NextApprover);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnExpenseTypeValidateBeforeExpValidation(ExpPostingSetup: Record "CEM Posting Setup"; ValidPostingSetupFound: Boolean; var Expense: Record "CEM Expense")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterNewCalculatedAccount(var Expense: Record "CEM Expense"; var NewCalculatedAccount: Code[20]; ExpPostingSetup: Record "CEM Posting Setup")
    begin
    end;
}

