table 6086321 "CEM Expense Allocation"
{
    Caption = 'Expense Allocation';
    DataCaptionFields = "Entry No.", "Continia User ID", "Expense Type", Description;

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
            begin
                GetExpense("Expense Entry No.");
                _Expense.TestField(Posted, false);
                if "Continia User ID" <> xRec."Continia User ID" then
                    if "Continia User ID" <> _Expense."Continia User ID" then
                        _Expense.TestField("Matched to Bank Transaction", false);
                _Expense.TestField(Status, _Expense.Status::Open);

                Validate("Expense Type");
            end;
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
        }
        field(7; "Date Created"; Date)
        {
            Caption = 'Date Created';
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
        }
        field(10; "No Refund"; Boolean)
        {
            Caption = 'No Refund';

            trigger OnValidate()
            begin
                if "No Refund" <> xRec."No Refund" then begin
                    PreventEditingPolicyAllocationLine(FieldCaption("No Refund"));
                end;
            end;
        }
        field(11; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate()
            begin
                if Amount <> xRec.Amount then
                    PreventEditingPolicyAllocationLine(FieldCaption(Amount));

                UpdateAmount(FieldNo(Amount));
            end;
        }
        field(12; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                if "Amount (LCY)" <> xRec."Amount (LCY)" then
                    PreventEditingPolicyAllocationLine(FieldCaption("Amount (LCY)"));

                UpdateAmount(FieldNo("Amount (LCY)"));
            end;
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
        }
        field(21; "Admin Comment"; Text[250])
        {
            Caption = 'Admin Comment';
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(28; "Amount w/o VAT"; Decimal)
        {
            Caption = 'Amount without VAT';

            trigger OnValidate()
            begin
                "VAT Amount" := Amount - "Amount w/o VAT";
            end;
        }
        field(29; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            Description = 'Obsollete';
        }
        field(31; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(50; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;

            trigger OnValidate()
            begin
                if "Job No." = '' then
                    Validate("Job Task No.", '');
                Validate(Billable, "Job No." <> '');
                AddDefaultDim(CurrFieldNo);
            end;
        }
        field(51; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

            trigger OnValidate()
            begin
                Validate(Billable, "Job No." <> '');
                AddDefaultDim(CurrFieldNo);
            end;
        }
        field(52; Billable; Boolean)
        {
            Caption = 'Billable';

            trigger OnValidate()
            begin
                if Billable then
                    "Job Line Type" := "Job Line Type"::Contract
                else
                    "Job Line Type" := "Job Line Type"::" ";
            end;
        }
        field(53; "Job Line Type"; Option)
        {
            Caption = 'Job Line Type';
            OptionCaption = ' ,Budget,Billable,Both Budget and Billable';
            OptionMembers = " ",Schedule,Contract,"Both Schedule and Contract";
        }
        field(60; "Cash/Private Card"; Boolean)
        {
            Caption = 'Cash/Private Card';
            Editable = false;
        }
        field(73; "Original Expense Entry No."; Integer)
        {
            Caption = 'Original Expense Entry No.';
            TableRelation = "CEM Expense";
        }
        field(109; "Expense Account Type"; Option)
        {
            Caption = 'Expense Account Type';
            OptionCaption = ' ,G/L Account,,,Item';
            OptionMembers = " ","G/L Account",,,Item;

            trigger OnValidate()
            begin
                if xRec."Expense Account Type" <> "Expense Account Type" then
                    Clear("Expense Account");
            end;
        }
        field(110; "Expense Account"; Code[20])
        {
            Caption = 'Expense Account';

            trigger OnValidate()
            var
                GLAcc: Record "G/L Account";
            begin
                case "Expense Account Type" of
                    "Expense Account Type"::"G/L Account":
                        begin
                            GLAcc.Get("Expense Account");
                            GLAcc.CheckGLAcc;
                        end;
                end;

                "Exp. Account Manually Changed" := CurrFieldNo = FieldNo("Expense Account");
                AddDefaultDim(CurrFieldNo);
            end;
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
        field(180; "Expense Type"; Code[20])
        {
            Caption = 'Expense Type';
            TableRelation = "CEM Expense Type";

            trigger OnValidate()
            var
                ContiniaUserSetup: Record "CDC Continia User Setup";
                ExpenseType: Record "CEM Expense Type";
                ExpPostingSetup: Record "CEM Posting Setup";
            begin
                if not ExpenseType.Get("Expense Type") then
                    Clear(ExpenseType);

                Validate("No Refund", ExpenseType."No Refund");
                ContiniaUserSetup.Get("Continia User ID");

                if (ExpenseType.Code <> '') and
                  ExpPostingSetup.FindPostingSetup(DATABASE::"CEM Expense", "Expense Type", "Country/Region Code", "Continia User ID",
                   ContiniaUserSetup."Expense User Group", false)
                then begin
                    Validate("Expense Account Type", ExpPostingSetup."Posting Account Type");
                    "Expense Account" := ExpPostingSetup."Posting Account No.";
                    "Gen. Prod. Posting Group" := ExpPostingSetup."Gen. Prod. Posting Group";
                    "Gen. Bus. Posting Group" := ExpPostingSetup."Gen. Bus. Posting Group";
                    "VAT Prod. Posting Group" := ExpPostingSetup."VAT Prod. Posting Group";
                    "VAT Bus. Posting Group" := ExpPostingSetup."VAT Bus. Posting Group";
                    "Tax Group Code" := ExpPostingSetup."Tax Group Code";
                end else begin
                    Clear("Expense Account Type");
                    Clear("Expense Account");
                    "Gen. Prod. Posting Group" := '';
                    "Gen. Bus. Posting Group" := '';
                    "VAT Prod. Posting Group" := '';
                    "VAT Bus. Posting Group" := '';
                    "Tax Group Code" := '';
                end;

                "Exp. Account Manually Changed" := false;
                AddDefaultDim(CurrFieldNo);
            end;
        }
        field(270; "No. of Attendees"; Integer)
        {
            CalcFormula = Count("CEM Attendee" WHERE("Table ID" = CONST(6086321),
                                                      "Doc. Ref. No." = FIELD("Entry No.")));
            Caption = 'No. of Attendees';
            Editable = false;
            FieldClass = FlowField;
        }
        field(300; "Expense Entry No."; Integer)
        {
            Caption = 'Expense Entry No.';
            NotBlank = true;
            TableRelation = "CEM Expense";
        }
        field(301; Modified; Boolean)
        {
            Caption = 'Modified';
        }
        field(304; "Amount %"; Decimal)
        {
            Caption = 'Amount %';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                if "Amount %" <> xRec."Amount %" then
                    PreventEditingPolicyAllocationLine(FieldCaption("Amount %"));

                UpdateAmount(FieldNo("Amount %"));
            end;
        }
        field(305; "Limit allocation"; Boolean)
        {
            Caption = 'Company policy allocation';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Expense Entry No.")
        {
            SumIndexFields = Amount, "Amount (LCY)", "Bank-Currency Amount", "VAT Amount";
        }
        key(Key3; "Expense Entry No.", Amount)
        {
        }
    }

    var
        _Expense: Record "CEM Expense";
        [InDataSet]
        _GotExpense: Boolean;
        _SkipSendToExpUser: Boolean;
        ConfRemAmount: Label 'The amount on the expense (%1 %2) and the total allocated amount (%1 %3) do not match. Do you want to close the page anyway?';
        ConfZeroLines: Label 'Allocations with 0 amount exist. Are you sure you want to keep these?';
        EmployeeModified: Label 'When changing %1 you need to create a new expense.';
        ExpTypeAttNotReq: Label 'The %1 %2 does not require attendees.';
        FieldCannotChangeDueToLimitErr: Label '%1 cannot  be changed. This allocation was auto-generated due to the company policies.';
        RemAmountMissmatchErr: Label 'The amount on the expense (%1 %2) and the total allocated amount (%1 %3) do not match.';
        Text002: Label 'The %1 must be inserted before you can show dimensions.';
        ZeroLinesErr: Label 'Allocations with amount 0 are not allowed.';

    local procedure UpdateAmount(CalledByFieldNo: Integer)
    var
        BankAccCurrency: Record Currency;
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        CurrencyDate: Date;
        CurrencyFactor: Decimal;
    begin
        GLSetup.Get;
        GetExpense("Expense Entry No.");
        if _Expense."Currency Code" <> '' then begin
            if "Document Date" = 0D then
                CurrencyDate := WorkDate
            else
                CurrencyDate := "Document Date";

            if _Expense.Amount <> 0 then
                CurrencyFactor := _Expense."Amount (LCY)" / _Expense.Amount
            else
                CurrencyFactor := 1;

            Currency.Get(_Expense."Currency Code");
            Currency.CheckAmountRoundingPrecision;
        end else begin
            Currency.InitRoundingPrecision;
            CurrencyFactor := 1;
        end;

        if "Bank Currency Code" <> '' then begin
            BankAccCurrency.Get("Bank Currency Code");
            BankAccCurrency.CheckAmountRoundingPrecision;
        end else
            BankAccCurrency.InitRoundingPrecision;

        case CalledByFieldNo of

            FieldNo(Amount):
                if _Expense.Amount = 0 then begin
                    "Amount (LCY)" := 0;
                    "Amount %" := 100;
                    "Bank-Currency Amount" := 0;
                    "VAT Amount" := 0;
                end else begin
                    "Amount (LCY)" := Round(Amount * CurrencyFactor);
                    "Amount %" := Amount / _Expense.Amount * 100;
                    "Bank-Currency Amount" :=
                      Round("Amount %" / 100 *
                       _Expense."Bank-Currency Amount", BankAccCurrency."Amount Rounding Precision");
                end;

            FieldNo("Amount %"):
                begin
                    Amount := Round("Amount %" / 100 * _Expense.Amount, Currency."Amount Rounding Precision");
                    "Amount (LCY)" := Round("Amount %" / 100 * _Expense."Amount (LCY)");
                    "Bank-Currency Amount" :=
                      Round("Amount %" / 100 *
                        _Expense."Bank-Currency Amount", BankAccCurrency."Amount Rounding Precision");
                end;

            FieldNo("Amount (LCY)"):
                begin
                    if _Expense."Amount (LCY)" = 0 then begin
                        Amount := 0;
                        "Amount %" := 100;
                        "Bank-Currency Amount" := 0;
                        "VAT Amount" := 0;
                    end else begin
                        Amount := Round("Amount (LCY)" / CurrencyFactor);
                        "Amount %" := "Amount (LCY)" / _Expense."Amount (LCY)" * 100;
                        "Bank-Currency Amount" :=
                          Round("Amount %" / 100 *
                           _Expense."Bank-Currency Amount", BankAccCurrency."Amount Rounding Precision");
                    end;
                end;
        end;

        "VAT Amount" := Round("Amount %" / 100 * _Expense."VAT Amount");
        "Amount w/o VAT" := Amount - "VAT Amount";
    end;


    procedure LookupDimensions(Editable: Boolean)
    begin
    end;

    procedure LookupExtraFields(Editable: Boolean)
    begin
    end;

    procedure GetLastEntryNo(): Integer
    begin
    end;

    procedure LookupPostingAccount(var Text: Text[1024]): Boolean
    begin
    end;

    procedure SendToExpenseUser(ShouldDelete: Boolean)
    begin
    end;

    procedure DrillDownAttendees()
    begin
    end;

    procedure GetAttendeesForDisplay() DisplayTxt: Text[150]
    begin
    end;


    procedure SetSkipSendToUser(Send: Boolean)
    begin
        _SkipSendToExpUser := Send;
    end;


    procedure AdjustAmtsToDecAndRecalc()
    var
        RemainingAmount: Decimal;
        RemainingAmountLCY: Decimal;
        RemainingAmtBankLCY: Decimal;
        RemainingVATAmt: Decimal;
    begin
        if "Expense Entry No." = 0 then
            exit;

        CalcRemainingAmounts("Expense Entry No.", 0, RemainingAmount, RemainingAmountLCY, RemainingAmtBankLCY, RemainingVATAmt);
        AdjustAmountsToDecimals("Expense Entry No.", RemainingAmount, RemainingAmountLCY, RemainingAmtBankLCY);
    end;


    procedure CalcRemainingAmounts(ExpEntryNo: Integer; ExcludeAllocEntryNo: Integer; var RemainingAmount: Decimal; var RemainingAmountLCY: Decimal; var RemainingAmtBankLCY: Decimal; var RemainingVATAmt: Decimal)
    var
        ExpenseAllocation: Record "CEM Expense Allocation";
    begin
        if ExpEntryNo = 0 then
            exit;

        ExpenseAllocation.SetCurrentKey("Expense Entry No.");
        ExpenseAllocation.SetRange("Expense Entry No.", ExpEntryNo);
        if ExcludeAllocEntryNo <> 0 then
            ExpenseAllocation.SetFilter("Entry No.", '<>%1', ExcludeAllocEntryNo);
        ExpenseAllocation.CalcSums(Amount, "Amount (LCY)", "Bank-Currency Amount");

        GetExpense(ExpEntryNo);
        RemainingAmount := _Expense.Amount - ExpenseAllocation.Amount;
        RemainingAmountLCY := _Expense."Amount (LCY)" - ExpenseAllocation."Amount (LCY)";
        RemainingAmtBankLCY := _Expense."Bank-Currency Amount" - ExpenseAllocation."Bank-Currency Amount";
        RemainingVATAmt := _Expense."VAT Amount" - GetAllocatedVATAmount(ExpEntryNo, ExcludeAllocEntryNo);
    end;

    local procedure GetAllocatedVATAmount(ExpEntryNo: Integer; ExcludeAllocEntryNo: Integer) VATAmount: Decimal
    var
        ExpenseAllocation: Record "CEM Expense Allocation";
    begin
        //TEMP FIX UNTIL MS RELEASES A SOLUTION FOR SUMINDEX APPENDED WHICH IS NOT CREATED AFTER UPGRADE
        ExpenseAllocation.SetCurrentKey("Expense Entry No.");
        ExpenseAllocation.SetRange("Expense Entry No.", ExpEntryNo);
        if ExcludeAllocEntryNo <> 0 then
            ExpenseAllocation.SetFilter("Entry No.", '<>%1', ExcludeAllocEntryNo);
        if ExpenseAllocation.FindSet() then
            repeat
                VATAmount := VATAmount + ExpenseAllocation."VAT Amount";
            until ExpenseAllocation.Next() = 0;
    end;


    procedure AdjustAmountsToDecimals(ExpEntryNo: Integer; RemainingAmount: Decimal; RemainingAmountLCY: Decimal; RemainingAmtBankLCY: Decimal)
    var
        ExpenseAllocation: Record "CEM Expense Allocation";
    begin
        if ExpEntryNo = 0 then
            exit;

        if (RemainingAmount = 0) and (RemainingAmountLCY <> 0) then begin
            ExpenseAllocation.SetCurrentKey("Expense Entry No.");
            ExpenseAllocation.SetRange("Expense Entry No.", ExpEntryNo);
            if ExpenseAllocation.FindLast then begin
                ExpenseAllocation."Amount (LCY)" := ExpenseAllocation."Amount (LCY)" + RemainingAmountLCY;
                ExpenseAllocation.Modify;
            end;
        end;

        if (RemainingAmount <> 0) and (RemainingAmountLCY = 0) then begin
            ExpenseAllocation.SetCurrentKey("Expense Entry No.");
            ExpenseAllocation.SetRange("Expense Entry No.", ExpEntryNo);
            if ExpenseAllocation.FindLast then begin
                ExpenseAllocation.Amount := ExpenseAllocation.Amount + RemainingAmount;
                ExpenseAllocation.Modify;
            end;
        end;

        if (RemainingAmount = 0) and (RemainingAmtBankLCY <> 0) then begin
            ExpenseAllocation.SetCurrentKey("Expense Entry No.");
            ExpenseAllocation.SetRange("Expense Entry No.", ExpEntryNo);
            if ExpenseAllocation.FindLast then begin
                ExpenseAllocation."Bank-Currency Amount" := ExpenseAllocation."Bank-Currency Amount" + RemainingAmtBankLCY;
                ExpenseAllocation.Modify;
            end;
        end;
    end;


    procedure ValidateAllocationConsistency(ExpEntryNo: Integer; ShowDialog: Boolean): Boolean
    var
        ExpenseAllocation: Record "CEM Expense Allocation";
    begin
        if ExpEntryNo = 0 then
            exit;

        _Expense.Get(ExpEntryNo);

        ExpenseAllocation.Reset;
        ExpenseAllocation.SetCurrentKey("Expense Entry No.");
        ExpenseAllocation.SetRange("Expense Entry No.", _Expense."Entry No.");
        ExpenseAllocation.SetFilter("Continia User ID", '<>%1', _Expense."Continia User ID");
        if not ExpenseAllocation.IsEmpty then
            Error(EmployeeModified, ExpenseAllocation.FieldCaption("Continia User ID"));

        Clear(ExpenseAllocation);
        ExpenseAllocation.SetCurrentKey("Expense Entry No.");
        ExpenseAllocation.SetRange("Expense Entry No.", Rec."Expense Entry No.");
        ExpenseAllocation.CalcSums(Amount);
        if (not ExpenseAllocation.IsEmpty) and (ExpenseAllocation.Amount <> _Expense.Amount) then
            if ShowDialog then
                exit(Confirm(ConfRemAmount, false, _Expense."Currency Code", _Expense.Amount, _Expense.Amount - ExpenseAllocation.Amount))
            else
                Error(RemAmountMissmatchErr, _Expense."Currency Code", _Expense.Amount, _Expense.Amount - ExpenseAllocation.Amount);

        if ZeroAmountLines then
            if ShowDialog then
                exit(Confirm(ConfZeroLines, false))
            else
                Error(ZeroLinesErr);

        exit(true);
    end;


    procedure DeleteAutoGeneratedEntries(): Boolean
    var
        ExpenseAllocation: Record "CEM Expense Allocation";
    begin
        ExpenseAllocation.SetCurrentKey("Expense Entry No.");
        ExpenseAllocation.SetRange("Expense Entry No.", Rec."Expense Entry No.");
        ExpenseAllocation.SetRange(Modified, false);
        ExpenseAllocation.DeleteAll(true);
    end;

    local procedure ZeroAmountLines(): Boolean
    var
        ExpenseAllocation: Record "CEM Expense Allocation";
    begin
        ExpenseAllocation.SetCurrentKey("Expense Entry No.");
        ExpenseAllocation.SetRange("Expense Entry No.", Rec."Expense Entry No.");
        ExpenseAllocation.SetRange(Amount, 0);
        exit(not ExpenseAllocation.IsEmpty);
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
                EMDimMgt.InsertDefaultDimAllocation(DATABASE::"Salesperson/Purchaser", ContiniaUser.GetSalesPurchCode, Rec);

            if ContiniaUser."Vendor No." <> '' then
                EMDimMgt.InsertDefaultDimAllocation(DATABASE::Vendor, ContiniaUser."Vendor No.", Rec);
        end;

        if "Expense Account" <> '' then
            EMDimMgt.InsertDefaultDimAllocation(DATABASE::"G/L Account", "Expense Account", Rec);

        if "Expense Type" <> '' then
            EMDimMgt.InsertDefaultDimAllocation(DATABASE::"CEM Expense Type", "Expense Type", Rec);

        if "Job No." <> '' then
            EMDimMgt.InsertDefaultDimAllocation(DATABASE::Job, "Job No.", Rec);

        if "Job Task No." <> '' then
            EMDimMgt.InsertDefaultDimAllocation(DATABASE::"Job Task", "Job Task No.", Rec);

        case ValidatedFieldNo of
            FieldNo("Continia User ID"):
                if ContiniaUser.Get("Continia User ID") then begin
                    if ContiniaUser.GetSalesPurchCode <> '' then
                        EMDimMgt.InsertDefaultDimAllocation(DATABASE::"Salesperson/Purchaser", ContiniaUser.GetSalesPurchCode, Rec);

                    if ContiniaUser."Vendor No." <> '' then
                        EMDimMgt.InsertDefaultDimAllocation(DATABASE::Vendor, ContiniaUser."Vendor No.", Rec);
                end;

            FieldNo("Expense Account"):
                if "Expense Account" <> '' then
                    EMDimMgt.InsertDefaultDimAllocation(DATABASE::"G/L Account", "Expense Account", Rec);

            FieldNo("Expense Type"):
                if "Expense Type" <> '' then
                    EMDimMgt.InsertDefaultDimAllocation(DATABASE::"CEM Expense Type", "Expense Type", Rec);

            FieldNo("Job No."):
                if "Job No." <> '' then
                    EMDimMgt.InsertDefaultDimAllocation(DATABASE::Job, "Job No.", Rec);

            FieldNo("Job Task No."):
                if "Job Task No." <> '' then
                    EMDimMgt.InsertDefaultDimAllocation(DATABASE::"Job Task", "Job Task No.", Rec);
        end;
    end;

    local procedure DeleteOldDefaultDim()
    var
        ContiniaUser: Record "CDC Continia User Setup";
        EMDimMgt: Codeunit "CEM Dimension Mgt.";
    begin
        if ContiniaUser.Get(xRec."Continia User ID") then begin
            if ContiniaUser.GetSalesPurchCode <> '' then
                EMDimMgt.DeleteDefaultDimAllocation(DATABASE::"Salesperson/Purchaser", ContiniaUser.GetSalesPurchCode, Rec);

            if ContiniaUser."Vendor No." <> '' then
                EMDimMgt.DeleteDefaultDimAllocation(DATABASE::Vendor, ContiniaUser."Vendor No.", Rec);
        end;

        if xRec."Expense Type" <> '' then
            EMDimMgt.DeleteDefaultDimAllocation(DATABASE::"CEM Expense Type", xRec."Expense Type", Rec);

        if xRec."Expense Account" <> '' then
            EMDimMgt.DeleteDefaultDimAllocation(DATABASE::"G/L Account", xRec."Expense Account", Rec);

        if xRec."Job No." <> '' then
            EMDimMgt.DeleteDefaultDimAllocation(DATABASE::Job, xRec."Job No.", Rec);

        if xRec."Job No." <> '' then
            EMDimMgt.DeleteDefaultDimAllocation(DATABASE::"Job Task", xRec."Job Task No.", Rec);
    end;

    local procedure CopyAttendees(Expense: Record "CEM Expense"; ExpenseAllocation: Record "CEM Expense Allocation")
    var
        Attendee: Record "CEM Attendee";
        Attendee2: Record "CEM Attendee";
        ExpenseType: Record "CEM Expense Type";
    begin
        if ExpenseType.Get(ExpenseAllocation."Expense Type") then
            if not ExpenseType."Attendees Required" then
                exit;

        Attendee.SetRange("Table ID", DATABASE::"CEM Expense");
        Attendee.SetRange("Doc. Ref. No.", Expense."Entry No.");
        if Attendee.FindSet then
            repeat
                Attendee2.Copy(Attendee);
                Attendee2."Table ID" := DATABASE::"CEM Expense Allocation";
                Attendee2."Doc. Ref. No." := ExpenseAllocation."Entry No.";
                Attendee2."Entry No." := Attendee2.GetNextEntryNo;
                Attendee2.Insert;
            until Attendee.Next = 0;
    end;


    procedure GetPostingDescription(): Text[1024]
    var
        ExpPostingDescFields: Record "CEM Exp. Posting Desc. Field";
    begin
        exit(ExpPostingDescFields.GetPostingDesc(DATABASE::"CEM Expense Allocation", 0, '', "Entry No."));
    end;

    local procedure GetExpense(ExpEntryNo: Integer)
    begin
        if not _GotExpense then
            _Expense.Get(ExpEntryNo);
    end;


    procedure SetExpense(ExpenseToSet: Record "CEM Expense")
    begin
        _Expense := ExpenseToSet;
        _GotExpense := true;
    end;

    local procedure PreventEditingPolicyAllocationLine(CalledByFieldTranslation: Text[250])
    var
        CompanyPolicy: Record "CEM Company Policy";
    begin
        if not "No Refund" then
            exit;

        // Check again if there is any setup asking for this limit.
        if not CompanyPolicy.GetRefundWithinPolicy(DATABASE::"CEM Expense", "Continia User ID", "Expense Type") then
            exit;

        // Is the allocation marked as created bt Company Policies?
        if "Limit allocation" then
            Error(FieldCannotChangeDueToLimitErr, CalledByFieldTranslation);
    end;


    procedure RecalculateAmounts(var BaseAmount: Decimal; var VATAmount: Decimal; var VATPercentage: Decimal)
    var
        ExpenseTemp: Record "CEM Expense" temporary;
        ExpenseAllocation: Record "CEM Expense Allocation";
        ExpenseAllocationTemp: Record "CEM Expense Allocation" temporary;
        Currency: Record Currency;
        GLAccount: Record "G/L Account";
        VATPostingSetup: Record "VAT Posting Setup";
        SalesTaxInterface: Codeunit "CEM Sales Tax Interface";
        VATPercentageAllocation: Decimal;
    begin
        ExpenseAllocationTemp.DeleteAll;
        ExpenseAllocationTemp := Rec;

        BaseAmount := 0;
        VATAmount := 0;
        VATPercentage := 0;

        if SalesTaxInterface.ShouldHandleCASalesTax then begin
            if SalesTaxInterface.IsAllocationSalesTaxLine(ExpenseAllocationTemp) then
                VATAmount := ExpenseAllocationTemp.Amount
            else
                BaseAmount := ExpenseAllocationTemp.Amount;
            exit;
        end;

        if ExpenseAllocationTemp."Expense Account" <> '' then
            if GLAccount.Get(ExpenseAllocationTemp."Expense Account") then
                if VATPostingSetup.Get(GLAccount."VAT Bus. Posting Group", GLAccount."VAT Prod. Posting Group") then
                    VATPercentage := VATPostingSetup."VAT %";

        if (ExpenseAllocationTemp."VAT Bus. Posting Group" <> '') or (ExpenseAllocationTemp."VAT Prod. Posting Group" <> '') then begin
            if ExpenseAllocationTemp."VAT Bus. Posting Group" = '' then
                ExpenseAllocationTemp."VAT Bus. Posting Group" := GLAccount."VAT Bus. Posting Group";
            if ExpenseAllocationTemp."VAT Prod. Posting Group" = '' then
                ExpenseAllocationTemp."VAT Prod. Posting Group" := GLAccount."VAT Prod. Posting Group";

            if VATPostingSetup.Get(ExpenseAllocationTemp."VAT Bus. Posting Group", ExpenseAllocationTemp."VAT Prod. Posting Group") then
                VATPercentage := VATPostingSetup."VAT %";
        end;

        if ExpenseAllocationTemp."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(ExpenseAllocationTemp."Currency Code");

        case VATPostingSetup."VAT Calculation Type" of
            VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                begin
                    VATAmount += Round(ExpenseAllocationTemp.Amount * (VATPercentage / 100), Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                    BaseAmount += Round(ExpenseAllocationTemp.Amount - Round(ExpenseAllocationTemp.Amount * (VATPercentage / 100),
                              Currency."Amount Rounding Precision", Currency.VATRoundingDirection), Currency."Amount Rounding Precision");
                end;
            VATPostingSetup."VAT Calculation Type"::"Normal VAT":
                begin
                    VATAmount += Round(ExpenseAllocationTemp.Amount * VATPercentage / (100 + VATPercentage), Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                    BaseAmount += Round(ExpenseAllocationTemp.Amount - Round(ExpenseAllocationTemp.Amount * VATPercentage / (100 + VATPercentage),
                              Currency."Amount Rounding Precision", Currency.VATRoundingDirection), Currency."Amount Rounding Precision");
                end;
        end;
    end;
}

