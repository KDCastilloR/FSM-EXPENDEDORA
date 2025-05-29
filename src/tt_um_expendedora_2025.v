module tt_um_expendedora_2025 (
    input  wire [7:0] ui_in,    // Entradas: ui_in[1:0] = moneda, ui_in[2] = comprarA, ui_in[3] = comprarB, ui_in[4] = reset
    output wire [7:0] uo_out,   // Salidas: uo_out[0] = listoA, uo_out[1] = listoB, uo_out[5:2] = total, uo_out[7:6] = cambio[1:0]
    input  wire       clk,
    input  wire       rst_n
);

    wire reset     = ~rst_n | ui_in[4];
    wire [1:0] moneda     = ui_in[1:0];
    wire comprarA = ui_in[2];
    wire comprarB = ui_in[3];

    wire listoA, listoB;
    wire [3:0] total, cambio;
    wire vendA, vendB;

    moore_fsm moore_inst (
        .clk(clk),
        .reset(reset),
        .moneda(moneda),
        .comprarA(comprarA),
        .comprarB(comprarB),
        .listoA(listoA),
        .listoB(listoB),
        .total(total),
        .vendA(vendA),
        .vendB(vendB)
    );

    mealy_fsm mealy_inst (
        .clk(clk),
        .reset(reset),
        .total(total),
        .vendA(vendA),
        .vendB(vendB),
        .cambio(cambio)
    );

    assign uo_out[0] = listoA;
    assign uo_out[1] = listoB;
    assign uo_out[5:2] = total[3:0];
    assign uo_out[7:6] = cambio[1:0]; // Solo 2 bits visibles

endmodule


module moore_fsm (
    input wire clk, reset,
    input wire [1:0] moneda,
    input wire comprarA, comprarB,
    output reg listoA, listoB,
    output reg [3:0] total,
    output reg vendA, vendB
);
    reg [2:0] estado, siguiente;
    reg [3:0] acumulado;

    parameter IDLE = 3'd0, WAIT = 3'd1;

    always @(posedge clk or posedge reset) begin
        if (reset)
            estado <= IDLE;
        else
            estado <= siguiente;
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            acumulado <= 4'd0;
        else if ((estado == IDLE || estado == WAIT) && moneda != 2'b00) begin
            case (moneda)
                2'b01: acumulado <= acumulado + 4'd2;
                2'b10: acumulado <= acumulado + 4'd3;
                2'b11: acumulado <= acumulado + 4'd4;
                default: acumulado <= acumulado;
            endcase
        end
    end

    always @(*) begin
        siguiente = estado;
        listoA = 0;
        listoB = 0;
        vendA = 0;
        vendB = 0;

        case (estado)
            IDLE: begin
                if (acumulado >= 2)
                    siguiente = WAIT;
            end
            WAIT: begin
                if (acumulado >= 3 && comprarB) begin
                    vendB = 1;
                    listoB = 1;
                    siguiente = IDLE;
                end else if (acumulado >= 2 && comprarA) begin
                    vendA = 1;
                    listoA = 1;
                    siguiente = IDLE;
                end
            end
        endcase
    end

    always @(*) begin
        total = acumulado;
    end
endmodule


module mealy_fsm (
    input wire clk, reset,
    input wire [3:0] total,
    input wire vendA, vendB,
    output reg [3:0] cambio
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            cambio <= 4'd0;
        else if (vendA)
            cambio <= total - 4'd2;
        else if (vendB)
            cambio <= total - 4'd3;
        else
            cambio <= 4'd0;
    end
endmodule
