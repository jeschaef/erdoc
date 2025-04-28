import { memo } from "react";
import NodeHandles from "./NodeHandles";

const DefaultMultivaluedAttribute = ({
  data,
}: {
  data: { label: string; isKey: boolean; entityIsWeak: boolean };
}) => (
  <>
    {/* Double circle effect with explicit sizing */}
    <div className="relative min-w-[70px] min-h-[70px] flex items-center justify-center">
      {/* Outer circle */}
      <div className="absolute inset-0 rounded-full border-2 border-yellow-400"></div>
      {/* Inner circle with padding */}
      <div className="relative rounded-full border-2 border-yellow-300 bg-yellow-100 m-2 p-2 w-[90%] h-[90%] flex items-center justify-center">
        <p
          className={`${data.isKey && "underline underline-offset-4"} ${
            data.entityIsWeak && "decoration-dashed"
          }`}
        >
          {data.label}
        </p>
      </div>
    </div>
    <NodeHandles
      TopHandleStyle={[{ top: "1%" }]}
      BottomHandleStyle={[{ bottom: "1%" }]}
      RightHandleStyle={[{ right: "1%" }]}
      LeftHandleStyle={[{ left: "1%" }]}
    />
  </>
);

export default memo(DefaultMultivaluedAttribute);