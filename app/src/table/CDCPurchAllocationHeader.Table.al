table 6085730 "CDC Purch. Allocation Header"
{
    Caption = 'Purchase Allocation Header';
    Permissions = TableData "CDC Purch. Allocation Header" = md,
                  TableData "CDC Purch. Allocation Line" = imd;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; "Pay-to Vendor No."; Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            Editable = false;
        }
        field(8; "Pay-to Name"; Text[50])
        {
            Caption = 'Pay-to Name';
        }
        field(9; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(10; "Vendor Cr. Memo No."; Code[35])
        {
            Caption = 'Vendor Cr. Memo No.';
        }
        field(11; "Vendor Posting Group"; Code[20])
        {
            Caption = 'Vendor Posting Group';
            TableRelation = "Vendor Posting Group";
        }
        field(12; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(13; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(14; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(15; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Posted,Reversed';
            OptionMembers = Open,Posted,Reversed;
        }
        field(16; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(17; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
        }
        field(18; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(19; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(20; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            Editable = false;
        }
        field(21; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
        }
        field(70; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            Editable = false;
        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            Caption = 'VAT Country/Region Code';
            Editable = false;
            TableRelation = "Country/Region";
        }
        field(100; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(126; "Pay-to IC Partner Code"; Code[20])
        {
            Caption = 'Pay-to IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Document No.")
        {
        }
    }
    procedure TestNoSeries()
    begin
    end;

    procedure UpdateCurrencyFactor()
    begin
    end;


    procedure UpdateFieldFromPurchHeader()
    begin
    end;

    procedure RecreatePurchAllocLines()
    begin
    end;

    procedure AutoCreateLines()
    begin
    end;

    procedure CreateLine(GLAccountNo: Code[20]; Amount: Decimal; PricesInclVAT: Boolean)
    begin
    end;

    procedure ReverseAll(PurchHeader: Record "Purchase Header")
    begin
    end;

    procedure ShowDocDim()
    var
        DimMgt: Codeunit DimensionManagement;
        OldDimSetID: Integer;
    begin
        if Status <> Status::Open then begin
            DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1', "No."));
            exit;
        end;

        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID", StrSubstNo('%1', "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if AllocLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;


    procedure SetSkipCopyDim(NewSkipCopyDim: Boolean)
    begin
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    begin
    end;

    procedure AllocLinesExist(): Boolean
    var
        PurchAllocLine: Record "CDC Purch. Allocation Line";
    begin
        PurchAllocLine.Reset();
        PurchAllocLine.SetRange("Document No.", "No.");
        exit(not PurchAllocLine.IsEmpty);
    end;
}