table 6085767 "CDC Purchase Header Info."
{
    Caption = 'Purchase Header DC Info.';
    Permissions = TableData "CDC Purch. Inv. Header Info." = i,
                  TableData "CDC Purch. Cr. Memo Hdr. Info." = i;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Approval Flow Code"; Code[10])
        {
            Caption = 'Approval Flow Code';
            TableRelation = "CDC Approval Flow";

            trigger OnValidate()
            var
                PurchHeader: Record "Purchase Header";
            begin
                PurchHeader.Get("Document Type", "No.");

                PurchHeader.TestField(Status, PurchHeader.Status::Open);
            end;
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        AppFlowAndAdvAppErr: Label 'Approval Flow Code and Advanced Approval can not be used at the same time.';

    procedure GetApprovalFlowCode(PurchHeader: Record "Purchase Header"): Code[10]
    var
        PurchHeaderDCInfo: Record "CDC Purchase Header Info.";
    begin
        if PurchHeaderDCInfo.Get(PurchHeader."Document Type", PurchHeader."No.") then
            exit(PurchHeaderDCInfo."Approval Flow Code");
    end;

    procedure LookupApprovalFlowCode(var Text: Text[1024]): Boolean
    begin
    end;

    procedure UpdateApprovalFlowCode(PurchHeader: Record "Purchase Header"; NewCode: Code[10])
    begin
    end;

    procedure TransferToPurchInvHeader(PurchHeader: Record "Purchase Header"; PurchInvHeader: Record "Purch. Inv. Header")
    var
        PurchInvHeaderDCInfo: Record "CDC Purch. Inv. Header Info.";
        PurchHeaderDCInfo: Record "CDC Purchase Header Info.";
    begin
        if not PurchHeaderDCInfo.Get(PurchHeader."Document Type", PurchHeader."No.") then
            exit;

        PurchInvHeaderDCInfo."No." := PurchInvHeader."No.";
        PurchInvHeaderDCInfo."Approval Flow Code" := PurchHeaderDCInfo."Approval Flow Code";
        PurchInvHeaderDCInfo.Insert();
    end;


    procedure TransferToPurchCrMemoHdr(PurchHeader: Record "Purchase Header"; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        PurchCrMemoHdrDCInfo: Record "CDC Purch. Cr. Memo Hdr. Info.";
        PurchHeaderDCInfo: Record "CDC Purchase Header Info.";
    begin
        if not PurchHeaderDCInfo.Get(PurchHeader."Document Type", PurchHeader."No.") then
            exit;

        PurchCrMemoHdrDCInfo."No." := PurchCrMemoHdr."No.";
        PurchCrMemoHdrDCInfo."Approval Flow Code" := PurchHeaderDCInfo."Approval Flow Code";
        PurchCrMemoHdrDCInfo.Insert();
    end;

    procedure IsApprovalFlowVisible(): Boolean
    begin
    end;
}