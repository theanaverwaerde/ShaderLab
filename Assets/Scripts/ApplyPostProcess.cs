using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ApplyPostProcess : MonoBehaviour
{
    [SerializeField] private Material mat;

    private void Awake()
    {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    // Called by the camera to apply the image effect
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        //mat is the material containing your shader
        Graphics.Blit(source, destination, mat);
    }
}
