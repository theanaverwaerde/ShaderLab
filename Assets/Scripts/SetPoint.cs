using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
public class SetPoint : MonoBehaviour
{
    private static readonly int Point = Shader.PropertyToID("_RotatePoint");
    private static readonly Vector2 Offset = new Vector2(0.5f, 0.5f);

    private void Update()
    {
        Vector2 point = (Vector2)transform.localPosition + Offset;
        gameObject.GetComponentInParent<MeshRenderer>().sharedMaterial.SetVector(Point, point);
    }
}
