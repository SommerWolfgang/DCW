table 6085731 "CDC Purch. Allocation Line"
{
    Caption = 'Purchase Allocation Line';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "CDC Purch. Allocation Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";

            trigger OnValidate()
            var
                GLAccount: Record "G/L Account";
                SourceCodeSetup: Record "Source Code Setup";
                DimMgt: Codeunit DimensionManagement;
                No: array[10] of Code[20];
                TempCode: Code[20];
                TableID: array[10] of Integer;
            begin
                GLAccount.Get("G/L Account No.");
                GLAccount.CheckGLAcc();
                "Gen. Prod. Posting Group" := GLAccount."Gen. Prod. Posting Group";
                Validate("VAT Prod. Posting Group", GLAccount."VAT Prod. Posting Group");

                GetPurchAllocHeader();
                SourceCodeSetup.Get();
                TableID[1] := DATABASE::"G/L Account";
                No[1] := "G/L Account No.";
                "Dimension Set ID" := DimMgt.GetDefaultDimID(
                  TableID, No, SourceCodeSetup.Purchases, TempCode, TempCode, PurchAllocHeader."Dimension Set ID", DATABASE::Vendor);
            end;
        }
        field(5; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then
                        Validate("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");

                Validate(Amount);
            end;
        }
        field(6; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                TestStatus();
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");

                Validate(Amount);
            end;
        }
        field(7; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                Validate("VAT Prod. Posting Group");
                Validate(Amount);
            end;
        }
        field(8; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                TestStatus();
                if not VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then
                    Clear(VATPostingSetup);
                "VAT %" := VATPostingSetup."VAT %";
                "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                "VAT Identifier" := VATPostingSetup."VAT Identifier";

                case "VAT Calculation Type" of
                    "VAT Calculation Type"::"Reverse Charge VAT",
                  "VAT Calculation Type"::"Sales Tax":
                        "VAT %" := 0;
                    "VAT Calculation Type"::"Full VAT":
                        begin
                            VATPostingSetup.TestField("Purchase VAT Account");
                            TestField("G/L Account No.", VATPostingSetup."Purchase VAT Account");
                        end;
                end;

                Validate(Amount);
            end;
        }
        field(9; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(10; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate()
            begin
                GetPurchHeader();

                "VAT Difference" := 0;
                Amount := Round(Amount, Currency."Amount Rounding Precision");
                case "VAT Calculation Type" of
                    "VAT Calculation Type"::"Normal VAT",
                    "VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            "VAT Base Amount" :=
                              Round(Amount * (1 - PurchHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                            "Amount Including VAT" :=
                              Round(Amount + "VAT Base Amount" * "VAT %" / 100, Currency."Amount Rounding Precision");
                        end;
                    "VAT Calculation Type"::"Full VAT":
                        begin
                            "VAT Base Amount" := 0;
                            if (CurrFieldNo = FieldNo(Amount)) or (Amount <> 0) then begin
                                "Amount Including VAT" := Amount;
                                Amount := 0;
                            end;
                        end;
                    "VAT Calculation Type"::"Sales Tax":
                        Error(SalesTaxNotSupportedErr, FieldCaption("VAT Calculation Type"), "VAT Calculation Type");
                end;

                UpdateVATAmounts();
            end;
        }
        field(11; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;

            trigger OnValidate()
            begin
                GetPurchAllocHeader();
                if PurchAllocHeader."Applies-to Doc. No." = '' then begin
                    GetPurchHeader();
                    "Amount Including VAT" := Round("Amount Including VAT", Currency."Amount Rounding Precision");

                    case "VAT Calculation Type" of
                        "VAT Calculation Type"::"Normal VAT",
                        "VAT Calculation Type"::"Reverse Charge VAT":
                            begin
                                Amount :=
                                  Round(
                                    "Amount Including VAT" /
                                    (1 + (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                                    Currency."Amount Rounding Precision");
                                "VAT Base Amount" :=
                                  Round(Amount * (1 - PurchHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                            end;
                        "VAT Calculation Type"::"Full VAT":
                            begin
                                Amount := 0;
                                "VAT Base Amount" := 0;
                            end;
                        "VAT Calculation Type"::"Sales Tax":
                            Error(SalesTaxNotSupportedErr, FieldCaption("VAT Calculation Type"), "VAT Calculation Type");
                    end;

                    UpdateVATAmounts();
                end;
            end;
        }
        field(12; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            Editable = false;
        }
        field(13; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(14; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(15; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(16; "VAT Difference"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;

            trigger OnValidate()
            begin
                "Amount Including VAT" := "Amount Including VAT" + "VAT Difference";
            end;
        }
        field(17; "VAT Identifier"; Code[20])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(18; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(19; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            TableRelation = "Dimension Set Entry";
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount, "Amount Including VAT";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestStatus();
    end;

    trigger OnInsert()
    begin
        TestStatus();
    end;

    trigger OnModify()
    begin
        TestStatus();
    end;

    var
        PurchAllocHeader: Record "CDC Purch. Allocation Header";
        Currency: Record Currency;
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        PurchHeader: Record "Purchase Header";
        VATPostingSetup: Record "VAT Posting Setup";
        SalesTaxNotSupportedErr: Label '%1 = %2 is not supported.';


    procedure GetPurchAllocHeader()
    begin
        if PurchAllocHeader."No." <> "Document No." then
            if not PurchAllocHeader.Get("Document No.") then
                Clear(PurchAllocHeader);
    end;


    procedure GetPurchHeader()
    begin
        GetPurchAllocHeader();
        if not PurchHeader.Get(PurchAllocHeader."Document Type", PurchAllocHeader."Document No.") then
            Clear(PurchHeader);

        if PurchHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            PurchHeader.TestField("Currency Factor");
            Currency.Get(PurchHeader."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;
    end;


    procedure SetupNewLine()
    begin
        GetPurchAllocHeader();
        "Gen. Bus. Posting Group" := PurchAllocHeader."Gen. Bus. Posting Group";
        "VAT Bus. Posting Group" := PurchAllocHeader."VAT Bus. Posting Group";
        "Currency Code" := PurchAllocHeader."Currency Code";
    end;


    procedure TestStatus()
    begin
        GetPurchAllocHeader();
        PurchAllocHeader.TestField(Status, PurchAllocHeader.Status::Open);
    end;


    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        TestField("Document No.");
        TestField("Line No.");

        GetPurchAllocHeader();

        if PurchAllocHeader.Status = PurchAllocHeader.Status::Open then
            "Dimension Set ID" :=
              DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', "Document No.", "Line No."))
        else
            DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', "Document No.", "Line No."));
    end;

    local procedure UpdateVATAmounts()
    var
        PurchAllocLine: Record "CDC Purch. Allocation Line";
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
    begin
        GetPurchHeader();

        PurchAllocLine.SetRange("Document No.", "Document No.");
        PurchAllocLine.SetFilter("Line No.", '<>%1', "Line No.");
        if Amount = 0 then
            if xRec.Amount >= 0 then
                PurchAllocLine.SetFilter(Amount, '>%1', 0)
            else
                PurchAllocLine.SetFilter(Amount, '<%1', 0)
        else
            if Amount > 0 then
                PurchAllocLine.SetFilter(Amount, '>%1', 0)
            else
                PurchAllocLine.SetFilter(Amount, '<%1', 0);
        PurchAllocLine.SetRange("VAT Identifier", "VAT Identifier");

        TotalAmount := 0;
        TotalAmountInclVAT := 0;

        if ("VAT Calculation Type" in
          ["VAT Calculation Type"::"Normal VAT", "VAT Calculation Type"::"Reverse Charge VAT"]) and ("VAT %" <> 0)
        then
            if PurchAllocLine.FindSet() then
                repeat
                    TotalAmount := TotalAmount + PurchAllocLine.Amount;
                    TotalAmountInclVAT := TotalAmountInclVAT + PurchAllocLine."Amount Including VAT";
                until PurchAllocLine.Next() = 0;

        if PurchHeader."Prices Including VAT" then
            case "VAT Calculation Type" of
                "VAT Calculation Type"::"Normal VAT",
                "VAT Calculation Type"::"Reverse Charge VAT":
                    begin
                        Amount :=
                          Round(
                            (TotalAmountInclVAT + "Amount Including VAT") / (1 + "VAT %" / 100), Currency."Amount Rounding Precision") - TotalAmount;
                        "VAT Base Amount" :=
                          Round(
                            Amount * (1 - PurchHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                        "Amount Including VAT" :=
                          TotalAmountInclVAT + "Amount Including VAT" -
                          Round(
                            (TotalAmount + "Amount Including VAT") * (PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                            Currency."Amount Rounding Precision", Currency.VATRoundingDirection()) -
                          TotalAmountInclVAT;
                    end;
                "VAT Calculation Type"::"Full VAT":
                    begin
                        if Amount <> 0 then
                            "Amount Including VAT" := Amount;
                        Amount := 0;
                        "VAT Base Amount" := 0;
                    end;
                "VAT Calculation Type"::"Sales Tax":
                    Error(SalesTaxNotSupportedErr, FieldCaption("VAT Calculation Type"), "VAT Calculation Type");
            end
        else
            case "VAT Calculation Type" of
                "VAT Calculation Type"::"Normal VAT",
                "VAT Calculation Type"::"Reverse Charge VAT":
                    begin
                        "VAT Base Amount" :=
                          Round(Amount * (1 - PurchHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                        "Amount Including VAT" :=
                          TotalAmount + Amount +
                          Round(
                            (TotalAmount + Amount) * (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                            Currency."Amount Rounding Precision", Currency.VATRoundingDirection()) - TotalAmountInclVAT;
                    end;
                "VAT Calculation Type"::"Full VAT":
                    begin
                        if Amount <> 0 then
                            "Amount Including VAT" := Amount;
                        Amount := 0;
                        "VAT Base Amount" := 0;
                    end;
                "VAT Calculation Type"::"Sales Tax":
                    Error(SalesTaxNotSupportedErr, FieldCaption("VAT Calculation Type"), "VAT Calculation Type");
            end;
    end;
}

